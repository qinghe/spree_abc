# I have to create own configuration class,  
# because that app_configuration_decorator is loaded after initialize,
# so in config/initializers/spree.rb, could not get seed_dir
# this new class would work 
module Spree
  class MultiSiteConfiguration < Preferences::Configuration
    #description start with global means it is for whole application, not just one site 
    preference :seed_dir, :string, :default => File.join(SpreeMultiSite::Engine.root,'db'), :description=>"global_seed_dir"
  end
end
