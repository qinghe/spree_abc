# order model by alphabet
module Spree
  Taxon.class_eval do
    include Context::Taxon
    before_destroy :remove_from_theme
  
    def remove_from_theme
      TemplateTheme.native.each{|theme|
        theme.unassign_resource_from_theme! self 
      }
    end
  end
end

