module PageTag
#                 template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
# template is collection of page_layout. each page_layout is section instance 
  class TemplateTag < Base
    class WrappedPageLayout < WrappedModel
      self.accessable_attributes=[:id,:title,:current_data_source,:wrapped_data_source_param, :data_filter,:current_contexts, :context_either?, :view_as_clickable?, :get_content_param_by_key]
      attr_accessor :section_id, :page_layout
      delegate *self.accessable_attributes, :to => :page_layout
      
      def initialize(collection_tag, page_layout, section_id)
        self.collection_tag = collection_tag
        self.page_layout = page_layout      
        self.section_id = section_id
      end
      
      def section
        page_layout.sections.find(section_id, :include=>[:section_piece])
      end
            
      #Usage: css selector for current section piece instance
      #       we may need css selector for current section instance
      def piece_selector
        if self.page_layout.id and self.section_id
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
        self.collection_tag.theme.assigned_resource_id(Spree::TemplateFile, page_layout)
      end
      def assigned_text_id
        self.collection_tag.theme.assigned_resource_id(Spree::TemplateText, page_layout)
      end
    end
    
    attr_accessor :page_layout_tree
    attr_accessor :param_values_tag, :menus_tag, :image_tag, :text_tag, :blog_posts_tag
    delegate :css, :to => :param_values_tag 
    delegate :menu,:menu2, :to => :menus_tag
    delegate :image, :to => :image_tag
    delegate :text, :to => :text_tag
    delegate :theme, :to => :page_generator
    attr_accessor :current_piece

    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.param_values_tag = ::PageTag::ParamValues.new(self)
      self.menus_tag = ::PageTag::Menus.new(self)
      self.image_tag = ::PageTag::TemplateImage.new(self)
      self.text_tag = ::PageTag::TemplateText.new(self)
      self.page_layout_tree = theme.page_layout.self_and_descendants()
    end
    
    #def id
    #  page_generator.theme.id
    #end
        
    #Usage: call this in template to initialize current section and section_piece
    #        should call this before call any method.
    #Params: page_layout_id, in fact, it is record of table page_layout. represent a section instance
    #        section_id, it is id of table section, represent a section_piece instance, could be 0. only select page_layout
    #                    
    def select(page_layout_id, section_id=0)
      #current selected section instance, page_layout record
      page_layout = page_layout_tree.select{|node| node.id == page_layout_id}.first
      #Rails.logger.debug "select #{page_layout.title}, section_id=#{section_id}"      
      self.current_piece = WrappedPageLayout.new(self, page_layout, section_id)
    end
    
    def products( wrapped_taxon )
      objs = []
      case self.current_piece.current_data_source
        when Spree::PageLayout::DataSourceEnum.gpvs
          #objs = menu.products
          #copy from taxons_controller#show
          searcher_params = {:taxon => wrapped_taxon.id}.merge(self.current_piece.wrapped_data_source_param ).merge(self.page_generator.resource_options)
          searcher = Spree::Config.searcher_class.new(searcher_params)
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = searcher.retrieve_products          
        when Spree::PageLayout::DataSourceEnum.gpvs_theme
          objs = Spree::MultiSiteSystem.with_context_site1_themes{
            searcher_params ={}
            if wrapped_taxon.persisted?
              searcher_params.merge!(:in_global_taxon=>wrapped_taxon.model )
            end
            searcher_params.merge!(self.current_piece.wrapped_data_source_param ).merge!(self.page_generator.resource_options)
Rails.logger.debug "......... searcher_params =#{searcher_params}"            
            searcher = Spree::Config.searcher_class.new(searcher_params)
            searcher.retrieve_products.theme_only.to_a # explicitly load some records, or default_scope would work when out of this block. 
          }        
        when Spree::PageLayout::DataSourceEnum.this_product
          #default_taxon.id is 0 
          if self.page_generator.resource.kind_of? Spree::Product
            objs = [self.page_generator.resource]         
          end
      end
      #Rails.logger.debug "self.current_piece=#{self.current_piece.title},wrapped_taxon = #{wrapped_taxon.name},objs=#{objs.inspect}"      
      if objs.present?
        objs = Products.new( self.page_generator, objs)
      end
      objs      
    end


    def posts( wrapped_taxon )
     
      objs = []
      case self.current_piece.current_data_source
        when Spree::PageLayout::DataSourceEnum.blog
          #copy from taxons_controller#show
          searcher_params = {:taxon => wrapped_taxon.id}.merge(self.current_piece.wrapped_data_source_param ).merge(self.page_generator.resource_options)
          searcher = SpreeTheme.post_class.searcher_class.new(searcher_params)
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = searcher.retrieve_posts          
        when Spree::PageLayout::DataSourceEnum.post
          if self.page_generator.resource.kind_of? Spree::Post
            objs = [self.page_generator.resource]
          end         
      end
      if objs.present?
        objs = Posts.new( self.page_generator, objs)
      end
      objs      
    end

  end
end
