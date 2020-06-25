module Spree
  class TemplateText < ActiveRecord::Base
    validates_presence_of :name
    #attr_accessible :name, :body
    default_scope ->{ where(:site_id=>SpreeTheme.site_class.current.id)}

    belongs_to :site

    #for resource_class.resourceful
    scope :resourceful, ->(theme){ where("1=1") }

    before_validation :normalize_permalink
    #before_destroy check is it assigned.
    private

    def normalize_permalink
      self.permalink = (permalink.blank? ? name.to_s.to_url : permalink).downcase.gsub(/(^[\/\-\_]+)|([\/\-\_]+$)/, "")
    end

  end
end
