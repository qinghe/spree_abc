Spree::Api::BaseController.class_eval do
  #add method current_site=
  include Spree::MultiSiteSystem
  prepend_before_filter :get_site
  
 
end