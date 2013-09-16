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