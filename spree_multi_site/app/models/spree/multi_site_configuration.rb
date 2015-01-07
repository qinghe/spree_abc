# I have to create own configuration class,  
# because that app_configuration_decorator is loaded after initialize,
# so in config/initializers/spree.rb, could not get seed_dir
# this new class would work 
module Spree
  class MultiSiteConfiguration < Preferences::Configuration
    #description start with global means it is for whole application, not just one site 
    preference :seed_dir, :string, :default => File.join(SpreeMultiSite::Engine.root,'db')
    # main site's domain, set it to first site when initialize seed.
    # it is required, in middleware, we compare it with request.host, 
    # it tell us to initialize site by short_name or domain.
    preference :domain, :string, :default => 'dalianshops.com'
  end
end
