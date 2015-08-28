module Spree
  class TemplateText < ActiveRecord::Base

    validates_presence_of :name
    #attr_accessible :name, :body
    #for resource_class.resourceful
    belongs_to :site
    scope :resourceful, ->(theme){ where("1=1") }
    default_scope ->{ where(:site_id=>SpreeTheme.site_class.current.id)}
    before_validation :normalize_permalink


    private

    def normalize_permalink
      self.permalink = (permalink.blank? ? name.to_s.to_url : permalink).downcase.gsub(/(^[\/\-\_]+)|([\/\-\_]+$)/, "")
    end

  end
end
