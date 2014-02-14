module PageTag
#                 template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
# template is collection of page_layout. each page_layout is section instance 
  class TemplateTag < Base
    class WrappedPageLayout < WrappedModel
      self.accessable_attributes=[:id,:data_source,:data_filter,:current_contexts, :context?, :context_either?]
      attr_accessor :section_id, :page_layout
      delegate *self.accessable_attributes, :to => :page_layout
      
      def initialize(collection_tag, page_layout, section_id)
        self.collection_tag = collection_tag
        self.page_layout = page_layout      
        self.section_id = section_id
      end
      
      def section_piece
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
          }.select{| ancestor_assigned_id | ancestor_assigned_id >0 }.first.to_i
        end        
        assigned_id
      end
      def assigned_image_id
        self.collection_tag.theme.assigned_resource_id(Spree::TemplateFile, page_layout)
      end
    end
    
    attr_accessor :page_layout_tree
    attr_accessor :param_values_tag, :menus_tag, :image_tag
    delegate :css, :to => :param_values_tag 
    delegate :menu,:menu2, :to => :menus_tag
    delegate :image, :to => :image_tag
    delegate :theme, :to => :page_generator
    attr_accessor :current_piece

    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.param_values_tag = ::PageTag::ParamValues.new(self)
      self.menus_tag = ::PageTag::Menus.new(self)
      self.image_tag = ::PageTag::TemplateImage.new(self)
      self.page_layout_tree = theme.page_layout.self_and_descendants()
    end
    
    def id
      page_generator.theme.id
    end
        
    #Usage: call this in template to initialize current section and section_piece
    #        should call this before call any method.
    #Params: page_layout_id, in fact, it is record of table page_layout. represent a section instance
    #        section_id, it is id of table section, represent a section_piece instance, could be 0. only select page_layout
    #                    
    def select(page_layout_id, section_id=0)
      #current selected section instance, page_layout record
      page_layout = page_layout_tree.select{|node| node.id == page_layout_id}.first
      self.current_piece = WrappedPageLayout.new(self, page_layout, section_id)
    end
    
  end
end
