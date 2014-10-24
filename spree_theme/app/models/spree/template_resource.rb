# this is class wrapper of tempate_theme.assigned_resource_ids
module Spree
  class TemplateResource
    attr_accessor :template_theme, :page_layout_id, :source_class_key, :source_id, :position
    
    def self.create_by_resource( template_theme, page_layout, resource,  position=0  )
      new(template_theme, page_layout.id, get_resource_class_key( resource), position ).save!
    end
    
    
    
    def self.get_resource_class_key( resource_class )
      # Spree::TemplateFile => "spree/template_file"
      resource_class.to_s.underscore
    end
    
    def self.get_page_layout_key( page_layout_id )
      page_layout_id.to_s
    end
    
    def initialize( template_theme, page_layout_id, source_key, source_id, position = 0 ) 
      self.template_theme = template_theme 
      self.page_layout_id =  page_layout_id
      self.source_key = source_key
      self.source_id  = source_id
      self.position = position
    end
    
    
    
    def save!
      page_layout_key = get_page_layout_key( page_layout_id )
      template_theme.assigned_resource_ids[page_layout_key]||={}
      template_theme.assigned_resource_ids[page_layout_key][resource_key]||=[]
      template_theme.assigned_resource_ids[page_layout_key][resource_key][position] = resource.id
      template_theme.save!
    end
    
    def destroy!
            # unassign resource from page_layout node
      def unassign_resource( resource_class, page_layout, resource_position=0 )
        #assigned_resource_ids={page_layout_id={:menu_ids=>[]}}
        self.assigned_resource_ids = {} unless assigned_resource_ids.present?        
        resource_key = get_resource_class_key(resource_class)
        page_layout_key = get_page_layout_key page_layout
        self.assigned_resource_ids[page_layout_key]||={}
        self.assigned_resource_ids[page_layout_key][resource_key]||=[]
        self.assigned_resource_ids[page_layout_key][resource_key][resource_position] = 0
        self.save! 
      end
      
      
    end
    
    
    def get_resource_class_by_key(  )
      # "spree/template_file" => Spree::TemplateFile
      resource_key.classify.constantize
    end
                

    
  end
end