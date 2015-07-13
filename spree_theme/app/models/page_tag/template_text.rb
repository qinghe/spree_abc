module PageTag
  class TemplateText
    attr_accessor :template_tag
    attr_accessor :resources_cache
     
    def initialize(template_tag)
      self.template_tag = template_tag
      self.resources_cache = {}
    end
    
        # get menu root assigned to section instance
    def get( wrapped_page_layout )
      key = wrapped_page_layout.to_key 
      unless resources_cache.key? key
        target_resource = nil
        resource_id = wrapped_page_layout.assigned_text_id
        if resource_id > 0          
          target_resource = Spree::TemplateText.find(resource_id)
        end
        resources_cache[key] = target_resource     
      end
      if resources_cache[key].present?
        resources_cache[key]
      else
        nil  
      end
    end
    
    def text
      template_text = get( template_tag.current_piece )      
      template_text.present? ? template_text.body : ''       
    end
    
  end
end