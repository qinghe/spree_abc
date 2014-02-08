module SpreeMultiSite
  class Middleware
    def initialize(app)
      @app = app
    end
 

    def call(env)
      request = Rack::Request.new(env)
      unless request.path.include?('.') # ignore .css, .js, .img
        site = get_site_from_request(request)
        Spree::Site.current = ( site || Spree::Site.first)
      end
      status, headers, body = @app.call(env)      
      [status, headers, body]
    end
    
    def get_site_from_request( request )
      site = nil      
      # test.david.com => www.david.com/?n=test.david.com
      # our domain is www.dalianshops.com 
      if request.params['n'].try(:split,'.') # support short_name.dalianshops.com
        short_name = request.params['n'].split('.').first
        site = Spree::Site.find_by_short_name(short_name)
      end

      if site.blank?  
        # support domain, ex. www.david.com
        # TODO should use public_suffix_service handle example.com.cn
        site = Spree::Site.find_by_domain(request.host) 
      end
      
      if(( Rails.env !~ /prduction/ ) && ( site.blank? ) )  
        # for development or test, enable get site from cookie
        #Rails.logger.debug "request.cookie_jar=#{request.cookie_jar.inspect},#{request.cookie_jar[:abc_development_domain]},#{request.cookie_jar['abc_development_domain']}"
        #string and symbol both OK.  cookie.domain should be exactly same as host, www.domain.com != domain.com
        cookie_domain = request.cookies['abc_development_domain'] 
        if cookie_domain.present?
          site = Spree::Site.find_by_domain( cookie_domain )
        end        
      end
      site
    end

  end
end