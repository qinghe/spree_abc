module Spree
  #it has to be in module Spree, website.template_theme require it. 
  class FakeWebsite < ActiveRecord::Base      
    include SpreeTheme::SiteHelper
    before_validation :set_short_name
    
    def set_short_name
      self.short_name = self.name.parameterize
    end

  end
end