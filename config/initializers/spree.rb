# Configure Spree Preferences
# 
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do: 
# config.setting_name = 'new value'

# override configuration by overriding file app_configuration.rb 
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  # config.site_name = "Spree Demo Site"
  # config.cache_static_content =false #for debug
  # config.freeze  
  #config.default_country_id = 41 #china
  #config.currency = 'CNY'
end
Spree.user_class = "Spree::User"

#TODO uncomment it after complete the db/sample
SpreeMultiSite::Config.seed_dir= File.join(Rails.application.root,'db')
