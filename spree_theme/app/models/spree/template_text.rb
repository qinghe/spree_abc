module Spree 
  class TemplateText < ActiveRecord::Base
    include Spree::AssignedResource::SourceInterface
    
    validates_presence_of :name
    attr_accessible :name, :body
    #for resource_class.resourceful
    scope :resourceful, ->(theme){ where("1=1") }
    default_scope ->{ where(:site_id=>Site.current.id)}
    before_validation :normalize_permalink


    # it is resource of template_theme
    def importable?    
      true
    end 
    
    def self.find_or_copy( text )
      existing_text = find_by_permalink( text.permalink )
      if existing_text.blank?
        cloned_branch = text.dup
        cloned_branch.site_id = Spree::Site.current.id
        cloned_branch.save!          
      end
      existing_text||cloned_branch

    end
    
    private

    def normalize_permalink
      self.permalink = (permalink.blank? ? name.to_s.to_url : permalink).downcase.gsub(/(^[\/\-\_]+)|([\/\-\_]+$)/, "")
    end
      
  end
end
