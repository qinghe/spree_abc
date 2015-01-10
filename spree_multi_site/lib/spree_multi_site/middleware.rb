module SpreeMultiSite
  class Middleware
    def initialize(app)
      @app = app
    end
 

    def call(env)
      request = Rack::Request.new(env)
      resource_extension = request.path[/\.[\w]+/]
      # ignore .css, .js, .img, except .json
      if resource_extension.nil? || resource_extension=='.json' 
        Spree::Store.current = get_store_from_request(request)
      end
      status, headers, body = @app.call(env)      
      [status, headers, body]
    end
    
    def get_store_from_request( request )
      # test.david.com => localhost:8080/?n=test.david.com
      # our domain is www.dalianshops.com 
      
      store = nil
      if request.params['n'].is_a? String
        store = Spree::Store.by_domain( request.params['n'] )
      end
      
      # support domain, ex. www.david.com
      # apache rewrite test.david.com => localhost:8080/?n=test.david.com, request.host is 'test.david.com'
      # TODO should use public_suffix_service handle example.com.cn
            
      if(( Rails.env !~ /prduction/ ) && ( store.blank? ) )  
        # for development or test, enable get site from cookie
        # string and symbol both OK.  cookie.domain should be exactly same as host, www.domain.com != domain.com
        # disable domain, some site have no domain, short_name always exists.      
        short_name = request.cookies['_dalianshops_short_name'] 
        if short_name.present?
          store = Spree::Store.unscoped.find_by_short_name( short_name )
        end        
      end
      store
    end

  end
end