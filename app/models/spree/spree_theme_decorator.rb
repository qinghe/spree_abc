Spree::Site.class_eval do
  include SpreeTheme::SiteHelper
    #override current
    def current
      ::Thread.current[:spree_site] || self.unknown 
    end
    
    def current=(some_site)
      ::Thread.current[:spree_site] = some_site      
    end
end

Spree::TemplateTheme.class_eval do
  belongs_to :site
  # no need default, want to get foreign template.
  #default_scope  { where(:site_id =>  Spree::Site.current.id) }
end    
