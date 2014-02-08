# Spree::BaseController.class_eval would not work
# Spree::UserSessionsController derive from Devise::SessionsController, it included Spree::Core::ControllerHelpers
require 'spree/core/controller_helpers'
class<< Spree::Core::ControllerHelpers
  def included_with_site_support(receiver)
    receiver.send :include, Spree::MultiSiteSystem
    receiver.send :helper_method, 'current_site'
    receiver.send :helper_method, 'current_site='
    receiver.send :helper_method, 'get_site_and_products'
    #puts "do something befor original included"
    included_without_site_support(receiver)
    receiver.prepend_before_filter :get_site_and_products #initialize site before authorize user in Spree::UserSessionsController.create
  end
  alias_method_chain :included, :site_support 
end


module Spree
  module MultiSiteSystem
    def current_site
      @current_site ||= (get_site_from_request  || Spree::Site.first)
    end
    
    def current_site=(new_site)
      #TODO raise error new_site.nil?
      session[:site_id] = new_site.nil? ? nil : new_site.id
      @current_site = new_site 
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
      
      if Rails.env !~ /prduction/ && site.blank?  
        # for development or test, enable get site from cookies
        if cookies[:abc_development_domain].present?
          site = Spree::Site.find_by_domain( cookies[:abc_development_domain] )
        elsif cookies[:abc_development_short_name].present?
          site = Spree::Site.find_by_short_name( cookies[:abc_development_short_name] )
        end        
      end
      site
    end
    
    def get_site_and_products
      Spree::Site.current = current_site
      logger.debug "current_site=#{current_site.id},get_layout=#{get_layout}"
      #raise ArgumentError  if @site.nil?
      #logger.debug "product.all=#{Spree::Product.all}"
      @taxonomies = (current_site ? current_site.taxonomies : [])
    end
    
    #override original methods 
    def get_layout
      current_site.layout.present? ? current_site.layout : Spree::Config[:layout]
    end
  
    def find_order      
      unless session[:order_id].blank?
        @order = Order.find_or_create_by_id(session[:order_id])
      else      
        @order = Order.create
      end
      @order.site = current_site
      session[:order_id] = @order.id
      @order
    end
  
  end
end