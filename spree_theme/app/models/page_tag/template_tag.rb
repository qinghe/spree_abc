require 'action_view/helpers/tag_helper'
require 'action_view/helpers/asset_tag_helper.rb'
module PageTag
#                 template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
# template is collection of page_layout. each page_layout is section instance
  class TemplateTag < Base
    # should not include helper, asset_host, asset_path would not work
    # include ActionView::Helpers::AssetTagHelper
    QQOnlineRegEx = /wpa\.qq\.com/

    class WrappedPageLayout < WrappedModel
      MaxTaxonDepth = 9999

      self.accessable_attributes=[:id,:title,:current_data_source, :wrapped_data_source_param, :data_filter, :data_source_order_by, :current_contexts, :context_either?,\
         :get_content_param_by_key, :get_data_source_param_by_key, :is_container?, :is_image?, :is_zoomable_image?, :effects, :section_pieces, \
         :content_css_class, :section_piece_resources]
      attr_accessor :section_id, :page_layout, :parent

      delegate *self.accessable_attributes, to: :page_layout
      alias_attribute :template, :collection_tag

      def initialize(collection_tag, page_layout, section_id)
        self.collection_tag = collection_tag
        self.page_layout = page_layout
        self.section_id = section_id
      end

      def section
        page_layout.sections.select{|section| section.id == section_id }.first
      end

      #Usage: css selector for current section piece instance
      #       we may need css selector for current section instance
      def piece_selector
        if self.page_layout.id && self.section_id
          "s_#{self.to_key}"
        end
      end

      # section piece have no html, only some css, in this case section_selector is required for css which apply to whole section
      # ex. container title.
      def section_selector
        "s_#{page_layout.id}_#{page_layout.section_id}"
      end

      # some css apply to children but all descendants, so we need a selector to get children
      # this selector indicate it is child of some parent
      # ex. content_layout.
      def as_child_selector
        "c_#{page_layout.parent_id}"
      end
      # some css apply to children but all descendants, so we need a selector to get children
      # this selector refer to its children
      def child_selector
        "c_#{page_layout.id}"
      end

      def to_key
        "#{page_layout.id}_#{section_id}"
      end

      def assigned_menu_id( resource_position=0 )
        assigned_id =  self.collection_tag.theme.assigned_resource_id(SpreeTheme.taxon_class, page_layout, resource_position)
        if assigned_id==0
          assigned_id = page_layout.ancestors.collect{|ancestor|
            self.collection_tag.theme.assigned_resource_id(SpreeTheme.taxon_class, ancestor, resource_position)
          }.select{| ancestor_assigned_id | ancestor_assigned_id >0 }.last.to_i #last could be nil
        end
        assigned_id
      end
      def assigned_image_id
        self.collection_tag.theme.assigned_resource_id( Spree::TemplateFile, page_layout )
      end
      def assigned_text_id
        self.collection_tag.theme.assigned_resource_id( Spree::TemplateText, page_layout )
      end

      def assgined_relation_type
        self.collection_tag.theme.assigned_resources( Spree::RelationType, page_layout ).first || self.collection_tag.theme.inherited_assigned_resources( Spree::RelationType, page_layout ).first
      end

      # start from 1
      def nth_of_siblings
        self.collection_tag.cached_page_layouts.values.select{|pl| pl.parent_id == page_layout.parent_id && pl != page_layout && pl.lft < page_layout.lft }.size + 1
      end

      # view content image_style ex. taxon_name, render as <a> or <span>?
      def clickable?
        # first bit is clickable
        get_content_param_by_key(:clickable)
      end

      def hoverable?
        # first bit is clickable
        get_content_param_by_key(:hoverable)
      end

      def zoomable?
        is_zoomable_image? && get_content_param_by_key(:zoomable)
      end

      def lightboxable?
        is_image? && get_content_param_by_key(:lightboxable)
      end

      def infinitescroll?
        get_data_source_param_by_key( :pagination_style ) == Spree::PageLayout::PaginationStyle.infinitescroll
      end

      # view content as grid.
      def column_count
        is_container? ?  get_content_param_by_key( :model_count_in_row ) : 0
      end

      def per_page
        return 0 if current_data_source.blank?
        is_container? ?  get_data_source_param_by_key( :per_page ).to_i : 0
      end

      # pagination as page links enable?
      def pagination_enable?
        # only container could have pagination
        is_container? && get_data_source_param_by_key( :pagination_enable )
      end

      def attribute_name
        get_data_source_param_by_key( :attribute_name ) || 'name'
      end

      def truncate_at
        get_content_param_by_key(:truncate_at)
      end

      def datetime_style
        get_content_param_by_key(:datetime_style)
      end
      # get href from
      #   content_param > current_data_item > default(home)
      def href
        if clickable?
           #  current_piece.url > current_data_item.url > current_page.url
           return page_layout.href if get_content_param_by_key( :context ) > 0
           return self.collection_tag.running_data_item.path if self.collection_tag.running_data_item.present?
           return self.collection_tag.current_page_tag.path
        end
      end

      # taxon depth for section menu
      def enabled_depth
        get_data_source_param_by_key(:depth) || MaxTaxonDepth
      end
    end

    attr_accessor :param_values_tag, :menus_tag, :images_tag, :text_tag, :blog_posts_tag
    delegate :css, :to => :param_values_tag
    delegate :menu,:menu2, :to => :menus_tag
    delegate :image, :to => :images_tag
    delegate :text, :to => :text_tag
    delegate :theme, :current_page_tag,  :to => :page_generator
    delegate :section_selector, :to =>:current_piece

    attr_accessor :current_piece
    #we have to store it in template, or missing after select another page_layout.
    attr_accessor :running_data_sources, :running_data_items, :running_data_source_sction_pieces, :cached_section_pieces
    attr_accessor :helpers
    delegate :tag, :image_tag, :content_tag, :to=> :helpers

    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.param_values_tag = ::PageTag::ParamValues.new(self)
      self.menus_tag = ::PageTag::Menus.new(self)
      self.images_tag = ::PageTag::TemplateImage.new(self)
      self.text_tag = ::PageTag::TemplateText.new(self)
      self.running_data_sources = []
      self.running_data_source_sction_pieces = [] # data_source belongs to section_piece
      self.running_data_items = []
      self.cached_section_pieces = {}
      self.helpers =  ActionController::Base.helpers
    end

    #Usage: call this in template to initialize current section and section_piece
    #        should call this before call any method.
    #Params: page_layout_id, in fact, it is record of table page_layout. represent a section instance
    #        section_id, it is id of table section, represent a section_piece instance, could be 0. only select page_layout
    #
    def select(page_layout_id, section_id=0)
      page_layout_id = self.current_piece.page_layout.id if page_layout_id==0
      key = "#{page_layout_id}_#{section_id}"
      self.current_piece  = cached_section_pieces[key]
      #current selected section instance, page_layout record
      if self.current_piece.nil?
        page_layout = cached_page_layouts[page_layout_id]
        self.current_piece = WrappedPageLayout.new(self, page_layout, section_id)
        unless page_layout.root?
          parent_key = "#{page_layout.parent_id}_0"
          #cached_section_pieces[parent_key] may be nil, we do not select
          self.current_piece.parent = cached_section_pieces[parent_key]
        end
        #Rails.logger.debug "-- cached_section_pieces =#{cached_section_pieces.keys.inspect}"
        #Rails.logger.debug "-- select #{page_layout.title}, key=#{key}, parent_id=#{page_layout.parent_id}, parent=#{self.current_piece.parent.try(:page_layout).try(:title)}"
        self.cached_section_pieces[key] = self.current_piece
      end
    end

    def products( wrapped_taxon, options={} )
      objs = []
      case self.current_piece.current_data_source
      when Spree::PageLayout::DataSourceEnum.gpvs, Spree::PageLayout::DataSourceEnum.related_products
          #copy from taxons_controller#show
          #searcher_params = { taxon: wrapped_taxon.resource_taxon_id }.merge(self.current_piece.wrapped_data_source_param ).merge( resource_params )
          searcher = Spree::Config.searcher_class.new( build_searcher_params( wrapped_taxon, options ))
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = searcher.retrieve_products
        when Spree::PageLayout::DataSourceEnum.gpvs_theme
            #searcher_params ={}
            #if wrapped_taxon.persisted?
            #  searcher_params.merge!(:search=>{:in_global_taxon=>wrapped_taxon.model} )
            #end
            #searcher_params.merge!(self.current_piece.wrapped_data_source_param ).merge!( resource_params )
          searcher = Spree::Config.searcher_class.new( build_searcher_params( wrapped_taxon ) )
          objs =  searcher.retrieve_products.theme_only.to_a # explicitly load some records, or default_scope would work when out of this block.
        when Spree::PageLayout::DataSourceEnum.this_product
          #default_taxon.id is 0
          if self.current_page_tag.product_tag.present?
            objs = [self.current_page_tag.product_tag]
          end
      end

      #Rails.logger.debug "self.current_piece=#{self.current_piece.title},wrapped_taxon = #{wrapped_taxon.name},objs=#{objs.inspect}"
      if objs.present?
        # wrapped_taxon may not be current taxon
        objs = Products.new( self.page_generator, objs, wrapped_taxon )
      end
      objs
    end


    def posts( wrapped_taxon )

      objs = []
      case self.current_piece.current_data_source
        when Spree::PageLayout::DataSourceEnum.blog
          #copy from taxons_controller#show
          #searcher_params = {taxon: wrapped_taxon.resource_taxon_id}.merge(self.current_piece.wrapped_data_source_param ).merge(self.page_generator.resource_options)
          searcher = SpreeTheme.post_class.searcher_class.new( build_searcher_params( wrapped_taxon ) )
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = searcher.retrieve_posts
        when Spree::PageLayout::DataSourceEnum.post
          if self.page_generator.post
            objs = [self.page_generator.post]
          end
      end
      if objs.present?
        objs = Posts.new( self.page_generator, objs, wrapped_taxon)
      end
      objs
    end

    # feature next_post, previous_post
    def related_posts( wrapped_taxon, options = {} )
      data_filter = ( options[:data_filter] || self.current_piece.data_filter )
      current_post = (self.running_data_item_by_class( Posts::WrappedPost ) || self.current_page_tag.post_tag )
      objs = []
      if self.page_generator.post.present?
        case data_filter
        when Spree::PageLayout::DataSourceFilterEnum.next
            item = Spree::PostClassification.where( taxon_id: wrapped_taxon.id, post_id: current_post.id ).first.try(:lower_item).try(:post)
            objs << item if item.present?
        when Spree::PageLayout::DataSourceFilterEnum.previous
            item = Spree::PostClassification.where( taxon_id: wrapped_taxon.id, post_id: current_post.id ).first.try(:higher_item).try(:post)
            objs << item if item.present?
        end
      end
      if objs.present?
        objs = Posts.new( self.page_generator, objs, wrapped_taxon)
      end
      objs
    end

    # products in same taxon
    def related_products( options = {} )
      #data_source = ( options[:data_source] || self.current_piece.current_data_source )
      data_filter = ( options[:data_filter] || self.current_piece.data_filter )

      current_product = (self.running_data_item_by_class( Products::WrappedProduct ) || self.current_page_tag.product_tag )
      if current_product
        case data_filter
        when Spree::PageLayout::DataSourceFilterEnum.next
          item = Spree::Classification.where( taxon_id: current_product.accurate_taxon_tag.id, product_id: current_product.id ).first.try(:lower_item).try(:product)
          item.present? ? Products.new( self.page_generator, [item], current_product.accurate_taxon_tag ) : []
        when Spree::PageLayout::DataSourceFilterEnum.previous
          item = Spree::Classification.where( taxon_id: current_product.accurate_taxon_tag.id, product_id: self.page_generator.resource.id ).first.try(:higher_item).try(:product)
          item.present? ? Products.new( self.page_generator, [item], current_product.accurate_taxon_tag ) : []
        else
          products( current_product.accurate_taxon_tag, { search:{ without_ids: [current_product.id]} } )
        end
      else
        []
      end
    end

    def next_product
      related_products( data_filter: 'next' ).first
    end

    def previous_product
      related_products( data_filter: 'previous' ).first
    end

    def related_products_by_relation_type
      current_product = (self.running_data_item_by_class( Products::WrappedProduct ) || self.current_page_tag.product_tag )
      relation_type = self.current_piece.assgined_relation_type
      if current_product && relation_type
        current_product.related_products( relation_type )
      else
        []
      end
    end

    def related_taxons( options = {} )
      data_filter = ( options[:data_filter] || self.current_piece.data_filter )
      taxon = (self.running_data_item_by_class( Menus::WrappedMenu ) || self.current_page_tag  )
      objs = []
      if taxon
        case data_filter
        when Spree::PageLayout::DataSourceFilterEnum.next
          item = taxon.right_sibling
          objs << item if item.present?
        when Spree::PageLayout::DataSourceFilterEnum.previous
          item = taxon.left_sibling
          objs << item if item.present?
        else
          objs = taxon.siblings
        end
      end
      objs.collect{|item| Menus::WrappedMenu.new(self.menus_tag, item)}
    end

    def next_taxon
      related_taxons( data_filter: 'next' ).first
    end

    def previous_taxon
      related_taxons( data_filter: 'previous' ).first
    end


    # in template_tag have no method link_to, content_tag, it have to be in base_helper
    def page_attribute(  attribute_name = nil, options = { } )
      attribute_name ||=  self.current_piece.attribute_name.to_sym
      page = options.delete(:data)
      unless page
        if attribute_name.to_s =~/root\_/
          # in this case, taxonomy have no running_data_item at this time.
          #   <container with resource menu>
          #     <taxonomy>
          #     <vertical menus>
          #   </container>
          page = self.menu
        else
          page = (self.running_data_item_by_class( Menus::WrappedMenu ) || self.current_page_tag)
        end
      end
      # page may be nil
      if page
        PageAttribute.new( current_piece, page ).get( attribute_name )
      else
        options.delete(:placeholder)
      end
    end

    # * params
    #   * attribute_name - symbol :name, :image, :thumbnail
    #   * options -
    #      * data -  Products::WrappedProduct
    #      * placeholder - string
    def product_attribute( attribute_name, options = { } )
      wrapped_model =  self.running_data_item_by_class( Products::WrappedProduct )
      wrapped_model = options.delete(:data) if options.key?( :data )

      if wrapped_model
        ProductAttribute.new( current_piece, wrapped_model, options ).get( attribute_name )
      else
        options.delete(:placeholder)
      end
    end

    # * params
    #   * options - file, get specified file of post
    def post_attribute(  attribute_name, options = { }  )
      wrapped_model = ( options.delete(:data) || self.running_data_item_by_class( Posts::WrappedPost ))
      PostAttribute.new( current_piece, wrapped_model, options ).get( attribute_name )  if wrapped_model
    end

    def site_attribute( attribute_name )
      website = current_page_tag.website
      attribute_value = ''
      if attribute_name==:favicon
        if website.favicon.present?
          attribute_value = tag('link', href: website.favicon.url(:original), type: "image/x-icon", rel: "shortcut icon" )
        end
      else
        attribute_value = website.send attribute_name
      end
      if self.current_piece.clickable?
        content_tag(:a, attribute_value, {href: '/'})
      elsif attribute_name==:name
        # make it as link anchor
        content_tag :span, attribute_value, {:id=>"p_#{self.current_piece.id}_#{website.site_id}"}
      else
        attribute_value
      end
    end

    def relation_attribute(  attribute_name, options = { }  )
      relation_type = self.current_piece.assgined_relation_type
      attribute_value = relation_type.send attribute_name
    end

    def font_awesome
      if current_piece.content_css_class.present?
        attribute_value = content_tag :i, "", { :class=>"fa "+current_piece.content_css_class }
        if self.current_piece.clickable?
          html_attributes = { href: self.current_piece.href }
          #always open a new window for qq online support
          html_attributes[:target] = '_blank' if html_attributes[:href] =~ QQOnlineRegEx
          attribute_value = content_tag( :a, attribute_value, html_attributes)
        end
        attribute_value
      end

    end

    def get_css_classes

      css_classes = ''
      # handling data iteration?
      # Rails.logger.debug "current_piece=#{current_piece.id},#{current_piece.title}, current_piece.is_container?=#{current_piece.is_container?}, self.running_data_sources.present?=#{self.running_data_sources.present?}"
      if current_piece.is_container?
        # page_layout.effects only apply to container, or bit conflict.
        css_classes << current_piece.effects.join(' ')
        if running_data_item.present?
          current_page = self.page_generator.current_page_tag
          column_count = self.running_data_source_sction_piece.column_count
          i = self.running_data_item_index
          #Rails.logger.debug "i=#{i}, column_count=#{column_count}, self.running_data_source_sction_piece=#{self.running_data_source_sction_piece.id}"
          css_classes << ' data_first' if column_count>0 && i==0
          css_classes << ' data_last'  if column_count>0 && ((i+1)%column_count==0)
          css_classes << " data_#{i+1}"

          case running_data_item
          when Menus::WrappedMenu
            css_classes << ' data_current' if running_data_item.current?
            css_classes << ' data_current_ancestor' if current_page.ancestor_ids.include?(running_data_item.id)
          when Products::WrappedProduct
          end

        end
      end
      if current_piece.parent.effects.present?
        css_classes << " child_#{current_piece.nth_of_siblings}"
      end
      css_classes << " zoomable" if current_piece.zoomable?
      css_classes << " hoverable" if current_piece.hoverable?
      css_classes << " lightboxable" if current_piece.lightboxable?
      css_classes << " infinitescroll" if current_piece.infinitescroll?

      css_classes

    end


    def cached_page_layouts
      if @cached_page_layouts.nil?
        @cached_page_layouts = theme.original_page_layouts.includes(:section).inject({}){ |hash,pl| hash[pl.id]=pl; hash }
      end
      @cached_page_layouts
    end

    def running_data_source
      running_data_sources.last
    end

    def running_data_source_sction_piece
      running_data_source_sction_pieces[ running_data_sources.size - 1 ]
    end

    def running_data_item
      running_data_items[ running_data_sources.size - 1 ]
    end

    def running_data_item_index
      #running_data_source could be array or resource
      case running_data_source
      when ModelCollection, Array #page.products,menu.children
        running_data_source.index( running_data_item)
      else # a page, a product
        0
      end
    end

    def running_data_source=( data_source )
      if data_source.nil?
        running_data_sources.pop
        running_data_source_sction_pieces.pop
        running_data_items.pop
      else
        running_data_sources.push data_source
        running_data_source_sction_pieces[ running_data_sources.size - 1 ] = current_piece
      end
    end
    def running_data_item=( data_item )
      running_data_items[ running_data_sources.size - 1 ] = data_item
    end

    def running_data_item_by_class( klass )
      running_data_items.select{|item| item.is_a? klass }.last
    end

    def build_searcher_params( wrapped_taxon, options={} )
      # a page_layout tree could have sveral gpvs assigned, each gpvs have own pagination
      pagination_params = self.page_generator.resource_options[:pagination_params]
      # for global search
      extrernal_searcher_params = self.page_generator.resource_options[:searcher_params]
      # self.current_piece.wrapped_data_source_param   per_page
      params = { }
      params.merge! self.current_piece.wrapped_data_source_param.slice(:per_page)

      #infinitescroll pagination
      if pagination_params[:pagination_plid].to_i == current_piece.id
        params.merge!( pagination_params.slice(:page) )
      end
      params.merge! extrernal_searcher_params

      order_by = self.current_piece.data_source_order_by

      case self.current_piece.current_data_source
      when Spree::PageLayout::DataSourceEnum.gpvs, Spree::PageLayout::DataSourceEnum.related_products
        if order_by == 'created_at_desc'
          params.merge!( search:{ sorts: 'created_at desc' } )
          # the newest products of site, ignore taxon
          #products in taxon is always positioned
        else
          params.merge!( taxon: wrapped_taxon.resource_taxon_id )
        end
      when Spree::PageLayout::DataSourceEnum.blog
        params.merge!( taxon: wrapped_taxon.resource_taxon_id )
      when Spree::PageLayout::DataSourceEnum.gpvs_theme
        params.merge!( taxon: wrapped_taxon.resource_taxon_id )
        #params.merge!(:search=>{:in_global_taxon=>wrapped_taxon.model} ) if wrapped_taxon.persisted?
      end
      #Rails.logger.debug " build_searcher_params =#{params.inspect} pagination_params=#{pagination_params.inspect} current_piece.id=#{current_piece.id}"

      params[:search] = options[:search] if options.key?( :search )
      params
    end


  end
end
