module Spree 
  class TemplateText < ActiveRecord::Base
    include AssignedResource::SourceInterface
    
    validates_presence_of :name
    attr_accessible :name, :body
    #for resource_class.resourceful
    scope :resourceful, ->(theme){ where("1=1") }
    default_scope ->{ where(:site_id=>Site.current.id)}
    make_permalink field: :slug


    # it is resource of template_theme
    def importable?    
      true
    end 
    
    def self.find_or_copy( text )
      existing_text = find_by_permalink( text.slug )
      if existing_text.blank?
        cloned_branch = text.dup
        cloned_branch.site_id = Spree::Site.current.id
        cloned_branch.save!          
      end
      existing_text||cloned_branch

    end
  end
end
