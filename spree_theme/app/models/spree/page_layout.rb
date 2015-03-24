# section param effect on content, we use data_source_param, such as pagination
# section param effect on css, we use content_param, such as clickable, image size
module Spree
  class PageLayout < ActiveRecord::Base
    #extend FriendlyId
    include Spree::Context::Base
    acts_as_nested_set :scope=>"root_id" # scope is for :copy, no need to modify parent_id, lft, rgt.
    belongs_to :section  
    has_many :themes, :class_name => "TemplateTheme",:primary_key=>:root_id,:foreign_key=>:page_layout_root_id
    has_many :param_values
    # this table is used by other site, should not use scope here
    # we want title to support multi-language, so disable friendly_id
    #friendly_id :title, :use => :slugged
    #has_many :full_set_nodes, -> { order 'lft' }, :class_name =>'PageLayout', :foreign_key=>:root_id, :primary_key=>:root_id
    has_many :sections, :class_name =>'Section', :foreign_key=>:root_id, :primary_key=>:section_id
    has_many :section_pieces, :through=>:sections
    # remove section relatives after page_layout destroyed.
    before_destroy :remove_section
    before_save :fix_data_source_param
    
    delegate :is_html_root?, :is_container?, :is_zoomable_image?, to: :section

    scope :full_html_roots, ->{ where(:is_full_html=>true,:parent_id=>nil) }
    #attr_accessible :section_id,:title
    attr_accessor :current_contexts, :inherited_contexts
    
    class << self
      # create component, it is partial layout, no html body, composite of some sections. 
      #notice: attribute section_id, title required
      # section.root.section_piece_id should be 'root'
      def create_layout(section, title, attrs={})
        #create record in table page_layouts
        layout = create!(:section_id=>section.id) do |obj|
          obj.title = title
          obj.site_id = SpreeTheme.site_class.current.id
          obj.attributes = attrs unless attrs.empty?
          obj.section_instance = 1
          obj.is_full_html = section.section_piece.is_root?
        end
        layout.update_attribute("root_id",obj.id)
        layout
      end
      
  
      # user copy decendants of a layout to new root layout while user copy theme to new theme.
      # since copy to new root, there is no section_instance confliction.
      def copy_decendants_to_new_parent(new_parent, original_parent, ordered_nodes)
        original_children =  ordered_nodes.select{|node| node.parent_id == original_parent.id }
        for node in original_children
          new_node = node.dup
          new_node.parent_id = new_parent.id
          new_node.root_id = new_parent.root_id
          new_node.save!
          if node.has_child?
            copy_decendants_to_new_parent(new_node, node, ordered_nodes )
          end
        end
        # copy_from_root_id means we have copied all decendants from that tree. 
        if new_parent.root?
          where( root_id: new_parent.id ).update_all(["copy_from_root_id=?",original_parent.id])
        end
      end
       
      # * description - copy :page_layout_tree whole tree
      # * params 
      # *   ordered_nodes -  whole tree node collection, it is ordered by left
      # * return - new ordered nodes
      def copy_to_new(ordered_nodes, new_attributes = nil)
        #create new root first, get new root id.
        original_root = ordered_nodes.first
        new_layout = original_root.dup
        new_layout.root_id = 0 # reset the lft,rgt.
        new_layout.save!
        new_layout.update_attribute("root_id", new_layout.id)  
        copy_decendants_to_new_parent(new_layout, original_root,  ordered_nodes)
        new_layout.reload.self_and_descendants
      end
    end
      
      # verify :come_contexts valid to :target_contexts
      #   home is special list
      # ex.  [:cart]  is valid to [:either]  taxon  <->  page_layout
      #      [:cart]  is valid to [:account, :checkout, :thankyou, :cart]
      #      [:cart]  is invalid to [:account]
      #      [:list]  is invalid to [:home]
      #      [:home]  is invalid to [:list]
      #      [:either] is valid to [:home]    page_layout <-> page_layout, called by update_section_context
      
      def self.verify_contexts( some_contexts, target_contexts )
        some_contexts = [some_contexts] unless some_contexts.kind_of?( Array )
        #Rails.logger.debug "some_contexts=#{some_contexts.inspect}, target_contexts=#{target_contexts}, [ContextEnum.either]=#{[ContextEnum.either].inspect}, is_valid = #{ret}"        
        ret = ( some_contexts==[ContextEnum.either] || target_contexts==[ContextEnum.either] || (target_contexts&some_contexts)==some_contexts )
        #|| (some_contexts==[ContextEnum.home]&&target_contexts.include?(ContextEnum.list)) 
      end

    #theme.document_path use it
    def site
      SpreeTheme.site_class.find( self.site_id )      
    end
    
    
    begin ' page_layout content'
      # a page_layout tree could be whole html or partial html, it depend's on self.section.section_piece.is_root?,  
      # it is only for root.
      
      # use as css class, later js select elements by those class
      def effects
        if @effect_classes.nil?
          @effect_classes =[]
          Section::HoverEffect.each_pair{|effect,val|
            #   00001000 
            # & 00001111  => val            
            @effect_classes << "hover_effect_#{effect}" if( (get_content_param & Section::HoverEffectMask) == val)
          }  
        end        
        @effect_classes
      end
      
      # a section could link to ....  ex. font-awesome  could link to home  
      def href
        if get_content_param_by_key( :clickable  )
          some_context = get_content_param_by_key( :context )
          SpreeTheme.taxon_class.get_route_by_context( some_context )
        end
      end
      
      def has_extra_selector?
        #child1,child2...              data1,data2...                                          zoomable                  columns>0, data_first,data_last 
        self.effects.present? || parent.effects.present? || parent.data_source.present? || self.get_content_param > 0 || parent.get_content_param > 0 
      end
      
      
      # * description - content_param is integer, each bit has own mean for each section.
      # * params
      #   * key - clickable, taxon_name, render as <a> or <span>?
      #         - image-size,  main product image size, [small|product|large|original]
      #         - columns, eliminate margin-right of last column - bit3,
      def get_content_param_by_key(key)
        default_truncate_at = 100;
        
        case key
        when :clickable 
          #bit 1, product:name,image, taxon:name,icon
          get_content_param&1 >0
        when :main_image_style
          #bit 2,3,4
          idx = (get_content_param&14)>>1
          #default is medium
          #   000x , 001x,  010x,    011x,    100x
          [:medium, :large, :product, :small, :original ].fetch( idx, :medium )
        when :thumbnail_style
          #bit 5,6,7
          idx = (get_content_param&112)>>4
          [:mini, :large, :medium, :small, :original].fetch( idx, :mini )
        when :zoomable
          #bit 8
          get_content_param&128 > 0        
        when :main_image_position
          #bit 9,   10,  product-image
          #   256 + 512 = 768
          (get_content_param&768)>>8                
        when :form_disabled 
          # in some case, we want to disable wrapped form of product attributes, 
          # ex. show product image only.
          # http://jssor.com/development/define-slides-html-code.html 
          # in slider_scrolling, jssor require <div>, not <form>
          #bit 11
          get_content_param&1024 > 0        
        when :model_count_in_row #bit 1,2,3,4
          #how many model this container
          get_content_param&15
        when :truncate_at # post summary
          #bit 2,3,4,5,6,7,8,9  
          #    2+4+8+16+32+64+128 = 254
          val = get_content_param&254
          val>0 ? val : default_truncate_at
        when :context # bootstrap_glyphicon could link to home/cart...
          #bit 2,3,4,5,6  max is 31
          #000010       000100   000110       001000     001010      001100    001110        010000    010010
          #2:home       4:cart   6:checkout   8:thanks   10:signup   12:login  14:account   16:blog    18:list
          #1            2        3            4          5           6         7            8          9   # keep it same as 
          (get_content_param&62)>>1 
        else 
          nil
        end 
      end
      
      #:clickable,:main_image_style,:thumbnail_style
      def update_content_param( options )
        options.each_pair{|key, val|
          content_param |= val.to_i          
        }        
        save!          
      end
      
      # we want to inherit content_param form section, page_layout could override it.
      # ex. section have hover effect, page_layout should have hover effect by default. 
      # get content from section, if self.content_param==0.
      def get_content_param
        self.content_param == 0 ? section.content_param : self.content_param        
      end
      
    end
    
    def has_child?
      return (rgt-lft)>1
    end
        
    # get applicable resources for self
    def applicable_reources
      self.section.self_and_descendants(:include=>:section_piece).select{|node|
        node.section_piece.resources
      }.select{|resource| resource.present?}
    end
    
    
    def partial_html
      pvs = self.param_values.includes(:section_param=>:section_piece_param)
      HtmlPage::PartialHtml.new(nil, self, nil, pvs)
    end
    
    begin 'modify page layout tree'      
      # * usage - copy whole tree
      # * return - root of new copied whole tree 
      def copy_to_new(new_attributes = nil)
        raise "only work for root" unless root? 
        #create new root first, get new root id.
        self.class.copy_to_new( self_and_descendants, new_attributes ).first
      end
       
      # it is not using
      # Usage: modify layout, add the section instance as child of current node into the layout,
      # Params: page_layout, instance of model PageLayout 
      # return: added page_layout record
      # 
      #def add_section(section, attrs={})
      #  # check section.section_piece.is_container?
      #  obj = nil
      #  if section.root? and self.section.section_piece.is_container      
      #    whole_tree = self.root.self_and_descendants
      #    section_instance = whole_tree.select{|xnode| xnode.section_id==section.id}.size.succ
      #    attrs[:title]||="#{section.slug}#{section_instance}"        
      #    obj = self.dup
      #    obj.section_id, obj.section_instance=section_id, section_instance
      #    obj.assign_attributes( attrs )
      #    obj.save!    
      #    obj.move_to_child_of(self)
      #  end
      #  obj
      #end
      
      # Usage: remove param_values belong to self in every theme while destroy self(page_layout record)
      def remove_section
        remove_param_value()
      end
      #Usage:  add param_value of section into this layout  
      def add_param_value(theme)
        # section_id, section_piece_param_id, section_piece_id, section_piece_instance, is_enabled, disabled_ha_ids
        # all section_params belong to section tree.
        # section_tree = self.section.self_and_descendants.includes(:section_params)
        # get default values of this section
        #TODO no need add param_value any more, use default value before user modify it
        layout_id = self.id
        layout_root_id = self.root_id
        for section_node in self.section.self_and_descendants.includes(:section_params)
          section_params = section_node.section_params
          for sp in section_params
            #use root section_id
            ParamValue.create(:page_layout_root_id=>layout_root_id, :page_layout_id=>layout_id) do |pv|
              pv.section_param_id = sp.id
              pv.theme_id = theme.id
              pv.pvalue = sp.default_value   
              #set default empty {} for now.
            end
          end
        end
        
      end 
       
      def remove_param_value()
        #layout_root_id = self.root_id
        #ParamValue.delete_all(["page_layout_id=? and theme_id in (?)", self.id, themes.collect{|obj|obj.id }])
        ParamValue.delete_all(["page_layout_id=? ", self.id])    
      end
      
      def demote
        if left_sibling.present?
          move_to_child_of( left_sibling )
        end
      end
      
      def promote
        unless root?
          move_to_right_of( parent )
        end        
      end
      
      # replace section with another section, this section only for development for now
      # ex. we developed a section with new feature, a page_layout tree want to have this feature, it could replace its original section with new section.
      #     for leaf we could just remove a section, then add new one. Root or some ancestor, replace is better way for developer and user.
      def replace_with( new_section)
        #1. delete all param_values of original section.
        #2. update section_id of current page_layout.  
        #3. add new param_values of new sections for each template theme which is using current page_layout
        self.remove_param_value()        
        new_section_instance =  self.root.self_and_descendants.select{|xnode| xnode.section_id==new_section.id }.size.succ
        self.section_id, self.section_instance=new_section.id, new_section_instance
        self.save!          
        self.themes.each{|theme|
          self.add_param_value(theme)  
        }
      end      
    end   
    
    begin 'section content, html, css, js'
      def build_content()
        tree = self.self_and_descendants.includes(:section=>[:section_piece, :full_set_nodes])
        # have to Section.all, we do not know how many section_pieces each section contained.
        sections = Section.includes(:section_piece)
        section_hash = sections.inject({}){|h, s| h[s.id] = s; h}
        css = build_css(tree, self, section_hash)
        html = build_html(tree,  section_hash)
        js = build_js(tree, sections)
        return html, css, js
      end
      
      # Usage: build html, js, css for a layout
      # Params: theme_id, 
      #         if passed, build css for that theme, or build css for default theme   
      def build_html(tree, section_hash)
        build_section_html(tree, self, section_hash)
      end
      
      def build_css(tree, node, section_hash, theme_id=0)
        css = node.section.build_css
        css.insert(0, get_section_script(node))    
        unless node.leaf?              
          children = tree.select{|n| n.parent_id==node.id}
          for child in children
            subcss = build_css(tree, child, section_hash)               
            css.concat(subcss)
          end
        end
        css
      end
    
      def build_js(tree, sections)
        section_ids = tree.collect{|node|node.section_id}
        section_piece_ids = sections.select{|s| section_ids.include?(s.root_id) or section_ids.include?(s.id) }.collect{|s| s.section_piece_id}
        js = ''
        if section_piece_ids.present?
          section_pieces = SectionPiece.find(section_piece_ids)
          js = section_pieces.inject(''){|sum, sp| sum.concat(sp.js); sum}
        end    
        return js
      end

      # highlight this page_layout.
      # or get subsection of section tree.      
      def css_selector( subsection = nil )
        subsection.blank? ? ".s_#{id}_#{section_id}" : ".s_#{id}_#{subsection.id}"
      end
      
    end
  
    #param: some_event could be a global_param_value changed event or a section_event.
    def subscribe_event?( some_event)
      section_events = self.section.subscribed_global_event_array
      section_events.include? some_event.event_name   
    end
    
    #usage: raise this global_param_value_event to whole layout tree or not 
    def raise_event?( some_event)
      reserved_section_events = self.section.global_event_array    
      reserved_section_events.include? some_event.event_name       
    end
    # get all descendants which reserved the :some_event
    def nodes_for_event(some_event)
      @subscribe_event_nodes_hash ||={}
      unless @subscribe_event_nodes_hash.key?  some_event.event_name
        nodes = self.root.self_and_descendants.select{|layout| layout.section.global_event_array.include? some_event.event_name}
        @subscribe_event_nodes_hash[some_event.event_name] = nodes
      end
      @subscribe_event_nodes_hash[some_event.event_name]
    end
    
    begin 'handle context' 
      # a section could have several contexts, means it could appear in serveral kind of pages 
      # return array of current contexts   
      def current_contexts
        if @current_contexts.blank?
          @current_contexts = ( self.section_context.present? ? self.section_context.split(',').map(&:to_sym) : inherited_contexts )
        end
        @current_contexts
      end
           
      # * params
      #   * new_context - one value of Contexts or an array of contexts 
      def update_section_context( new_context)
        new_context  = [new_context] unless new_context.kind_of?( Array )
        new_context = new_context.map(&:to_sym) # "".to_sym == ContextEnum.either
        raise ArgumentError unless self.class.verify_contexts( new_context, inherited_contexts)
        # test would check section_context,so keep it as string
        self.update_attribute(:section_context,new_context.join(','))
        if new_context.first != ContextEnum.either
          #update descendant's context, 
          self.descendants.where(["section_context!=?",ContextEnum.either]).each{|node|
            #only reset context if desendant's context is invalid for new_context.
            unless self.class.verify_contexts( node.current_contexts, new_context )
              node.update_attribute(:section_context, ContextEnum.either)
            end
          }
          #TODO correct descendants's data_source
          self.update_data_source( DataSourceEmpty )
        end
      end
      
      # called in current_page_tag
      def valid_context?(some_context)
        self.class.verify_contexts some_context.to_sym, current_contexts
      end
      def context_cart?
        current_contexts.include? ContextEnum.cart
      end
      def context_account?
        current_contexts.include? ContextEnum.account
      end
      def context_list?
        current_contexts.include? ContextEnum.list
      end
      def context_detail?
        current_contexts.include? ContextEnum.detail
      end
      
      #def context_either?
      #  current_contexts.include? ContextEnum.either
      #end

    end
  
    begin 'handle data source'
      # * data source has two parts, data and filter, separated by '|'
      # * current data_source could be nil
      def current_data_source        
        self.data_source.present? ? self.data_source.to_sym : DataSourceEmpty 
      end
      
      def inherited_data_source      
        return DataSourceEmpty if self.root?
        ancestor_data_source = self.ancestors.collect{|page_layout| page_layout.data_source }.last      
        ancestor_data_source.present? ? ancestor_data_source.to_sym : DataSourceEmpty
      end
      
      # verify new_data_source
      def update_data_source( new_data_source )
        # update self data_source
        original_data_source = self.data_source 
        self.data_source = new_data_source
        if new_data_source.blank? || self.is_valid_data_source?
          self.update_attribute(:data_source,new_data_source )
          #verify descendants, fix them.
          verify_required_descendants = self.descendants.where('data_source!=?', DataSourceEmpty)
          for node in verify_required_descendants
            unless node.is_valid_data_source?
              node.update_data_source(DataSourceEmpty)
            end
          end
        else
          self.data_source = original_data_source
        end
        self
      end
      
      # * is self.data_source valid to ancestors
      def is_valid_data_source?
        is_valid = false
        if self.current_data_source != DataSourceEmpty
          if self.inherited_data_source == DataSourceEmpty # top level data source 
            section_contexts = self.current_contexts
            if  section_contexts.length == 1
              available_data_sources =  ContextDataSourceMap[section_contexts.first]
              if available_data_sources.present?
                is_valid = ( available_data_sources.include? self.current_data_source )
              end 
            else
              #TODO validate data source for more than on section contexts
              is_valid = true
            end         
          else #sub level data source
#Rails.logger.debug "self.inherited_data_source=#{self.inherited_data_source}"            
            is_valid = ( DataSourceChainMap[self.inherited_data_source].include? self.current_data_source)
          end
        else
          is_valid = true  
        end      
#Rails.logger.debug "is_valid = #{is_valid}"        
        is_valid
      end
      
      # get available data sources for self
      def available_data_sources
        data_sources = []
        if self.current_contexts.size == 1
          the_context = self.current_contexts.first 
          if  the_context != ContextEnum.either
            the_data_source = self.inherited_data_source
            if the_data_source == DataSourceEmpty # top level data source 
              data_sources =  ContextDataSourceMap[the_context]
            else
              data_sources = DataSourceChainMap[the_data_source]
            end
          end
        end
        data_sources
      end 
      
      def wrapped_data_source_param
        params = {}
        if data_source_param.present?
          if current_data_source == DataSourceEnum.gpvs || current_data_source == DataSourceEnum.blog
            splited_params = data_source_param.split(',')
            params[:per_page]= splited_params[0].to_i
            params[:pagination_enable] = ( splited_params[1].nil? ? true : (splited_params[1]=='1') )
          end
        end
        params
      end
      
      def get_data_source_param_by_key( key )
        wrapped_data_source_param[key]
      end
    end
    
    
    private
    # section_context could be more than one. 
    def inherited_contexts
      #ancestors order by lft
      if @inherited_contexts.blank?
        ancestor_context = self.ancestors.where('section_context!=?','').collect{|page_layout| page_layout.section_context }.last      
        @inherited_contexts = ( ancestor_context.present? ? ancestor_context.split(',').map(&:to_sym) : [ContextEnum.either] )
      end
      @inherited_contexts
    end
    
    def inherited_section_context
      #ancestors order by lft
      ancestor_context = self.ancestors.where('section_context!=?','').collect{|page_layout| page_layout.section_context }.last      
      ancestor_context.present? ? ancestor_context.to_sym : ContextEnum.either
    end
    
    
    def build_section_html(tree, node, section_hash) 
      return '' unless node.is_enabled?
      subpieces = ""
      unless node.leaf?              
        subnodes = tree.select{|n| n.parent_id==node.id}
        for child in subnodes
          next unless child.is_enabled?
          subpiece = build_section_html(tree, child, section_hash)
          subpieces.concat(subpiece)
        end
      end  
      piece = node.section.build_html       
      # replace ~~selectors~~ with ex. 's_112_2 c_111'
      unless node.root?
        offline_css = "s_#{node.id}_#{node.section_id} c_#{node.parent_id} #{node.css_class}"
        if node.has_extra_selector?
          piece.sub!('~~selector~~', "#{offline_css} <%=@template.get_css_classes %>")             
        else
          piece.sub!('~~selector~~', offline_css) 
        end          
        #if node.content_css_class.present?
        #  piece.sub!(/\bcontent_css_class_placeholder/, node.content_css_class)
        #end      
      end
      # if node.root?
      #   piece.insert(0,init_vars)  
      # end
      # select current page_layout at end of subpieces,  pagination required, data_souce_param is on current page_layout   
      subpieces << get_section_script(node) if subpieces.present?
       
      #piece may contain several ~~content~~, the deepest one is first.           
      if(pos = (piece=~/~~content~~/))
        if node.data_source.present? #node.data_source.singularize
          case node.current_data_source
            # var_collection has to vary in name, may be nested. 
            # data_source, data_item is for column index computing.
            when DataSourceEnum.gpvs, DataSourceEnum.this_product, DataSourceEnum.gpvs_theme
              # for this_product, we have to wrapped with form, or option_value radio would not work.
              form_disabled = node.get_content_param_by_key( :form_disabled )
              form_start = "<%= form_for :order, :url => populate_orders_path do |f| %>" unless form_disabled
              form_end =   "<% end %>" unless form_disabled
              subpieces = <<-EOS1 
              <% @template.running_data_source= @template.products( (defined?(page) ? page : @current_page) ) %>
              <% @template.running_data_source.each(){|product| @template.running_data_item = product %>
                  #{form_start}
                  #{subpieces}
                  #{form_end}
              <% } %>
              #{get_pagination}
              <% @template.running_data_source = nil %>
              EOS1
              #set var_collection  to nil, or render pagination more times
            when DataSourceEnum.blog, DataSourceEnum.post
              subpieces = <<-EOS1 
              <% @template.running_data_source= @template.posts( (defined?(page) ? page : @current_page) ) %>
              <% @template.running_data_source.each{|post| @template.running_data_item = post %>
                  #{subpieces}
              <% } %>
              #{get_pagination}
              <% @template.running_data_source = nil %>
              EOS1
            when DataSourceEnum.taxon
              #assigned menu could be root or node
              subpieces = <<-EOS3 
              <% if @template.menu.present? %>
                <% if @template.menu.root? %>
                  <% @template.running_data_source= @template.menu.children %>
                  <% @template.running_data_source.each{|page| @template.running_data_item = page %> #{subpieces} <%}%>
                  <% @template.running_data_source = nil %>
                <% else %>  
                  <% @template.running_data_source= @template.menu %>  
                  <% @template.running_data_source.tap{|page| @template.running_data_item = page %> #{subpieces} <%}%>
                  <% @template.running_data_source = nil %>
                <% end %>              
              <% end %>              
              EOS3
          end
        end    
        # we recovery template.select after ~~content~~
        piece.insert(pos,subpieces)        
      end
       
      if node.section_context.present?
        # should set current page_layout before do valid_context.
        piece = <<-EOS2
          <% if @current_page.valid_context? %>
          #{piece}
          <% end %>
        EOS2
      end  
      
      piece = "#{get_section_script(node)}  #{piece} "

      # remove ~~content~~ however, node could be a container.
      # in section.build_html, ~~content~~ have not removed. 
      # there could be more than one ~~content~~, use gsub!
      piece.gsub!(/~~content~~/,'')
      piece       
    end
  
    def get_section_script(node)
      # we have to call @template.select(g_page_layout_id); 
      # valid_context require current page_layout, we should not move valid_context? into section.
      "<% @template.select(#{node.id}, 0) %>" 
    end
    
    # show pagination when section is configured, data_source_param > 0
    # ex. in home page, we have product list, we do not want to show pagination even products.count > Spree::Config[products_per_page]
    def get_pagination(  )
      # section is configured and datasource have pages
      # notice: current piece is data iterator parent at present.  ex. product_list(current_piece)->one_product
      "<%= paginate( @template.running_data_source ) if @template.current_piece.per_page>0 && @template.current_piece.pagination_enable? && @template.running_data_source.try( :has_pages? ) %> " 
    end
        
    # Do not support add_layout_tree now. Page layout should be full html, Keep it simple. 
    # since we add feature 'section_context' and 'data_source', should not allow user use this method, it may cause section_context conflict.
    # user copy prebuild layout tree to another layout tree as child.
    # copy it self and decendants to new parent. this only for root layout.
    # include theme param values. add theme param values to all themes which available to the new parent.
    def add_layout_tree(copy_layout_id)
      copy_layout = self.class.find(copy_layout_id)
      raise "only for root layout" unless copy_layout.root?
      copy_layout.copy_to_new_parent(self)        
    end
      
    #  cached_whole_tree, it is whole tree of new parent, to compute new added section instance.
    #  added_section_ids, new added section ids, but not in cache.
    #  root_layout.copy_to()
    def copy_to_new_parent(new_parent, cached_whole_tree = nil, added_section_ids=[])
      
      cached_whole_tree||= new_parent.root.self_and_descendants
      
      new_section_instance =  ( cached_whole_tree.select{|xnode| xnode.section_id==self.section_id}.size +
        added_section_ids.select{|xid| xid==self.section_id}.size ).succ
      
      clone_node = self.dup # do not call clone, or modify itself
      clone_node.parent_id = new_parent.id
      clone_node.root_id = new_parent.root_id
      clone_node.section_instance = new_section_instance
      clone_node.copy_from_root_id =  self.root_id
      clone_node.save!    
      added_section_ids << clone_node.section_id
  
      # it should only have one theme.
      copy_theme = self.root.themes.first
      table_name = ParamValue.table_name    
      table_column_names = ParamValue.column_names
      table_column_names.delete('id')
      # copy param values to all available themes
      for theme in clone_node.root.themes
        table_column_values  = table_column_names.dup
        table_column_values[table_column_values.index('page_layout_root_id')] = clone_node.root_id
        table_column_values[table_column_values.index('page_layout_id')] = clone_node.id
        table_column_values[table_column_values.index('theme_id')] = theme.id
        sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE ((page_layout_root_id=#{self.root_id} and page_layout_id =#{self.id}) and theme_id =#{copy_theme.id} )! 
        self.class.connection.execute(sql) 
      end 
          
      for node in self.children       
        node.copy_to_new_parent(clone_node, cached_whole_tree, added_section_ids)
      end                  
    end
    
    # empty data_source_param when data_source is empty
    def fix_data_source_param
      if self.data_source.blank? && self.data_source_param.present?
        self.data_source_param = ''
      end
    end     
  end
  
end
