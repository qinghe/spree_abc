module Spree
  class TemplateText < ActiveRecord::Base
    extend FriendlyId
    friendly_id :slug_candidates, :use => :slugged

    validates_presence_of :name
    #attr_accessible :name, :body
    #for resource_class.resourceful
    belongs_to :site
    scope :resourceful, ->(theme){ where("1=1") }
    default_scope ->{ where(:site_id=>SpreeTheme.site_class.current.id)}

    private

    def slug_candidates
        [
          :name,
          [:name, :site_id],
        ]
    end
  end
end
