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
      
      store = Spree::Store.by_domain( request.host )

      # support domain, ex. www.david.com
      # apache rewrite test.david.com => localhost:8080/?n=test.david.com, request.host is 'test.david.com'
      # TODO should use public_suffix_service handle example.com.cn

      if(( Rails.env !~ /prduction/ ) && ( store.blank? ) )
        # for development or test, enable get site from cookie
        # string and symbol both OK.  cookie.domain should be exactly same as host, www.domain.com != domain.com
        # disable domain, some site have no domain, short_name always exists.
        # we can not easily modify cookies except firefox, we'll add default_site for debug page on other browser.
        # we could set default site for missing site as well.
        short_name = request.cookies['_dalianshops_short_name']
        if short_name.present?
          store = Spree::Store.unscoped.find_by_code( short_name )
        end
        #support request.host for development
        store ||= Spree::Store.default

      end
      store
    end

  end
end
