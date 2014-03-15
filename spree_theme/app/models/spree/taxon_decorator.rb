module Spree
  Taxon.class_eval do
    include Context::Taxon
    before_destroy :remove_from_theme
    #for resource_class.resourceful
    scope :resourceful,->(theme){ roots }
    
    def remove_from_theme
      TemplateTheme.native.each{|theme|
        theme.unassign_resource_from_theme! self 
      }
    end
    
    
    
  end
end

