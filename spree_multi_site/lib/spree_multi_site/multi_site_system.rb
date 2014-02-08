# Spree::BaseController.class_eval would not work
# Spree::UserSessionsController derive from Devise::SessionsController, it included Spree::Core::ControllerHelpers
require 'spree/core/controller_helpers/common'
class<< Spree::Core::ControllerHelpers::Common
  #def included_with_site_support(receiver)
  #  receiver.send :include, Spree::MultiSiteSystem
  #  included_without_site_support(receiver)
  #  #receiver.prepend_before_filter :get_site #initialize site before authorize user in Spree::UserSessionsController.create
  #end
  #alias_method_chain :included, :site_support
  
  #Spree::Api::BaseController would include  MultiSiteSystem, get_layout should not in it.
  #override original methods 
  def get_layout
    Spree::Site.current.layout.present? ? Spree::Site.current.layout : Spree::Config[:layout]
  end
end
      
module Spree
  module MultiSiteSystem
    def current_site
      @current_site ||= (get_site_from_request  || Spree::Site.first)
    end
       
    def get_site_from_request
      site = nil      
      # test.david.com => www.david.com/?n=test.david.com
      # our domain is www.dalianshops.com 
      if params[:n].try(:split,'.') # support short_name.dalianshops.com
        short_name = params[:n].split('.').first
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
        if request.cookie_jar[:abc_development_domain].present?
          site = Spree::Site.find_by_domain( request.cookie_jar[:abc_development_domain] )
        elsif request.cookie_jar[:abc_development_short_name].present?
          site = Spree::Site.find_by_short_name( request.cookie_jar[:abc_development_short_name] )
        end        
      end
      site
    end
    
    def get_site
      Spree::Site.current = current_site
      Rails.logger.debug "current_site=#{Spree::Site.current.id}"
      #raise ArgumentError  if current_site.nil?
      #logger.debug "product.all=#{Spree::Product.all}"
      #@taxonomies = (current_site ? current_site.taxonomies : [])
    end
      
  end
end