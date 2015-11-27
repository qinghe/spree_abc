module Spree
  #since spree support multi store,  FakeWebsite respresent store now.
  #it has to be in module Spree, website.template_theme require it.
  class FakeWebsite < ActiveRecord::Base
    include SpreeTheme::SiteHelper
    before_validation :set_short_name
    has_many :stores
    
    class << self
      def current
      #  if Thread.current[:spree_site].nil?
      #    website = self.find_or_initialize_by_domain_and_name('design.dalianshops.com','DalianShops Design Site' )
      #    #or Rails.env.development?
      #    if website.new_record?
      #      website.id = 2
      #      website.theme_id = 1
      #      website.save!
      #    end
      #    Thread.current[:spree_site] = website
      #  end
        Thread.current[:spree_site]
      end

      def current=(some_site)
        ::Thread.current[:spree_site] = some_site
      end
    end

    def set_short_name
      self.short_name = self.name.to_url
    end

  end
end
