module Spree
  module Context
    module Taxon
      extend ActiveSupport::Concern
      include Spree::Context::Base
      
      included do
        class_attribute :request_fullpath

        cattr_accessor :context_routes
         #(:either, :list,:detail,:cart,:account,:checkout, :thanks,:signup,:login)
        self.context_routes = { 
          ContextEnum.home =>"/",
          ContextEnum.account =>"/account",
          ContextEnum.checkout =>"/checkout",
          ContextEnum.cart =>"/cart",
          ContextEnum.signup =>"/signup",
          ContextEnum.login =>"/login",
          ContextEnum.either =>"/" #default_taxon for context :either is home
          }
        #FIXME what if home is not assigned to theme? 
        def self.home
          where(:page_context=> 1 ).first
        end
          
        def path
          return href if href.present?
          context_routes[current_context] || "/#{self.id}"     
        end
      end
      
      # context of default taxon vary in request_fullpath
      # ex. /cart  context is cart
      #     /user  context is account
      # return :either(detail or list), cart, checkout, register, login
      def current_context
        # consider query_string d=www.dalianshops.com and preview path /template_themes/2/preview
        if request_fullpath.present? #for current page, request_fullpath is present
          case self.request_fullpath
            when /^\/[\d]+\/[\d]+/
              ContextEnum.detail
            when /^\/cart/
              ContextEnum.cart
            when /^\/user/
              ContextEnum.account
            when /^\/password/ 
              ContextEnum.password
            when /^\/account/,/users\/[\d]+\/edit/ #users/2/edit  
              ContextEnum.account 
            when /^\/login/, /^\/checkout\/registration/
              ContextEnum.login   
            when /^\/signup/
              ContextEnum.signup
            when /^\/checkout/
              ContextEnum.checkout
            when /^\/orders/
              ContextEnum.thanks
            when /^\/signup/
              ContextEnum.signup
            when /^\/post/
              ContextEnum.post
            when '/',/^\/\?/, /^\/template_themes/ 
              ContextEnum.home
            else
              ContextEnum.list
          end
        else
          case self.page_context
            when 1 #home
              ContextEnum.home
            when 2 #cart
              ContextEnum.cart
            when 3 #checkout
              ContextEnum.checkout
            when 4 #thanks
              ContextEnum.thanks
            when 5 #signup
              ContextEnum.signup
            when 6 #login
              ContextEnum.login
            when 7 #accout
              ContextEnum.account
            else
              ContextEnum.list  
          end
        end
      end
      
      def context_either?
        current_context ==ContextEnum.either
      end
      
      #is it a home page?
      def page_home?
        page_context == 1
      end      
    end
  end
  
end
  