SpreeTheme.taxon_class.class_eval do
    include Spree::Context::Taxon
    before_destroy :remove_from_theme
    #for resource_class.resourceful
    scope :resourceful,->(theme){ roots }
    
    belongs_to :replacer, class_name: 'Spree::Taxon', foreign_key: 'replaced_by' 


    def remove_from_theme
      Spree::TemplateTheme.native.each{|theme|
        theme.unassign_resource_from_theme! self 
      }
    end
    
    def extra_html_attributes
      if @extra_html_attributes.nil?
        if html_attributes.present?
          @extra_html_attributes = Hash[ html_attributes.split(';').collect{|pair| pair.split(':')} ] 
        end
        @extra_html_attributes ||= {}
      end
      @extra_html_attributes
    end
    
end

