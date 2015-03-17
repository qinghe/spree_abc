module PageTag
  class WebsiteTag < Base
    class_attribute :accessable_attributes_from_store,  :accessable_attributes_from_site
    self.accessable_attributes_from_store = [:site, :name, :site_id]
    self.accessable_attributes_from_site = [:design?]  
    delegate *self.accessable_attributes_from_store, to: :store
    delegate *self.accessable_attributes_from_site, to: :site
    
    def store
      page_generator.theme.store
    end
    
    #def get(function_name)
    #  self.site.send function_name
    #end
    
    # template_release is nil if designing
    def public_path(target)      
      page_generator.theme.file_path(target)       
    end
    
  end
end
