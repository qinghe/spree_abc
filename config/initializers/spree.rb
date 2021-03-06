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
#SpreeTheme.site_class = "Spree::Site"
#SpreeTheme.taxon_class = "Spree::Taxon"
#SpreeTheme.post_class = "Spree::Post"
#TODO uncomment it after complete the db/sample
#SpreeMultiSite::Config.tap do |config|
#end
SpreeAbc::Application.configure do
  config.spree_multi_site.site_scope_required_classes_with_image_from_other_gems.merge!( { cover: Spree::Post })
  config.spree_multi_site.preferences.seed_dir= File.join(SpreeAbc::Application.root,'db')
end
SpreeEditor::Config.tap do |config|
  config.ids = "product_description taxon_description template_text_body  post_body"
  config.current_editor = "CKEditor"
end