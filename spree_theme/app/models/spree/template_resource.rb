# this is class wrapper of tempate_theme.assigned_resource_ids
module Spree
  class TemplateResource
    attr_accessor :template_theme, :page_layout_key, :page_layout_id, :source_key, :source_id, :position
    alias_attribute :to_i, :source_id 
    
    def initialize( template_theme, page_layout_key, source_key, source_id, position = 0 ) 
      self.template_theme = template_theme 
      self.page_layout_key =  page_layout_key # serialized hash key is string
      self.page_layout_id =  page_layout_key.to_i
      self.source_key = source_key
      self.source_id  = source_id
      self.position = position
    end
    
    
    #add
    def save!
      template_theme.assigned_resource_ids[page_layout_key]||={}
      template_theme.assigned_resource_ids[page_layout_key][source_key]||=[]
      template_theme.assigned_resource_ids[page_layout_key][source_key][position] = source_id
      template_theme.save!
    end
    
    #delete
    def destroy!
      # unassign resource from page_layout node
      template_theme.assigned_resource_ids[page_layout_key][source_key][position] = 0
      template_theme.save!
    end
    
    def update_attribute!(key,val)
      if key == :page_layout_id
        new_page_layout_key = val.to_s
        template_theme.assigned_resource_ids[new_page_layout_key] = template_theme.assigned_resource_ids.delete(page_layout_key)
        template_theme.save!
      end
    end    
    
    def source_class(  )
      # "spree/template_file" => Spree::TemplateFile
      source_key.classify.constantize
    end
                
    def source
      source_class.find_by_id source_id
    end
    
  end
end