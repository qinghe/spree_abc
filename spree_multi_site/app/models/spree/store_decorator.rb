Spree::Store.class_eval do
  include Spree::MultiSiteSystem

  clear_validators!
  
  #override original current
  def self.current(domain = nil)
    #UnknownStore.instance is for test only
    ::Thread.current[:spree_store] || UnknownStore.instance
  end
  
  def self.current=(some_store)
    ::Thread.current[:spree_store] = some_store      
  end
    
  def self.by_domain( domain )
    current_store = if domain.is_a? String
      if domain.end_with? Spree::Site.system_top_domain
        short_name = domain.split('.').first
        self.unscoped.find_by_code(short_name)                  
      else 
        self.unscoped.by_url(domain).first
      end
    else
      self.unscoped.first
    end
    current_store    
  end
  
  # we can not easily modify cookies except firefox, we'll add default_site for debug page on other browser.
  # we could set default site for missing site as well.           
  def self.default
    unscoped.where( default: true ).first
  end  
    
  #app_configuration require site_id  
  class UnknownStore
    include Singleton
    def id
      0
    end
    
    def site
      #app_configuration require site_id
      Struct.new(:id).new(0)
    end
  end
end