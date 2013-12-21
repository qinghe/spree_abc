# I have to create own configuration class,  
# because that app_configuration_decorator is loaded after initialize,
# so in config/initializers/spree.rb, could not get seed_dir
# this new class would work 
module Spree
  class ThemeConfiguration < Preferences::Configuration
    #description start with global means it is for whole application, not just one site 
    def site_class
      FakeWebsite
    end
    def taxon_class
      Spree::Taxon   
    end
    
  end
end
