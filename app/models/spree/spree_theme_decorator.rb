Spree::Site.class_eval do
  include SpreeTheme::SiteHelper
end

Spree::TemplateTheme.class_eval do
  belongs_to :site
  # no need default, want to get foreign template.
  #default_scope  { where(:site_id =>  Spree::Site.current.id) }
end    
