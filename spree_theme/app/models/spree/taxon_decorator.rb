SpreeTheme.taxon_class.class_eval do
    include Spree::Context::Taxon
    before_destroy :remove_from_theme
    #for resource_class.resourceful
    scope :resourceful,->(theme){ roots }
    
    belongs_to :replacer, class_name: 'Spree::Taxon', foreign_key: 'replaced_by' 
    attr_accessible :page_context, :replaced_by

    
    def self.find_or_copy( taxon )
      raise "only support taxon root" unless taxon.root?
      
      existing_taxon = roots.find_by_permalink( taxon.permalink )
      existing_taxon||= taxon.copy
    end

    
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
    
    #copy self into current site
    def copy
      #raise "only copy taxon from design site" unless taxon.site.design?
      #raise "taxon exists in current site" if self.class.exists(:permalink=>self.permalink)
      
      #copy from http://stackoverflow.com/questions/866528/how-to-best-copy-clone-an-entire-nested-set-from-a-root-element-down-with-new-tr
      h = { self => self.clone } #we start at the root    
      ordered = self.descendants 
      #clone subitems
      ordered.each do |item|
        h[item] = item.dup
      end    
      #resolve relations
      ordered.each do |item|
        cloned = h[item]
        item_parent = h[item.parent]
        item_parent.children << cloned if item_parent
        # handle icon
      end
      h[self].save!
      h[self]
    end   
    # it is resource of template_theme
    def importable?    
      root?
    end 
end

