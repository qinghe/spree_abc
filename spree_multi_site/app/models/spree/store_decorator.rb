Spree::Store.class_eval do
  include Spree::MultiSiteSystem

  clear_validators!
  
  #override original current
  def self.current(domain = nil)
    ::Thread.current[:spree_store]
  end
  
  def self.current=(some_store)
    ::Thread.current[:spree_store] = some_store      
  end
    
  def self.by_domain( domain )
    current_store = if domain.is_a? String
      if domain.end_with? Spree::Site.system_top_domain
        short_name = domain.split('.').first
        self.unscoped.find_by_short_name(short_name)                  
      else 
        self.unscoped.by_url(domain).first
      end
    else
      self.unscoped.first
    end
    current_store    
  end
  
end