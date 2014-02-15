module Spree
  module Context
    module Taxon
      extend ActiveSupport::Concern
      include Spree::Context::Base
      
      included do
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
                  
        def path
          context_routes[current_context] || "/#{self.id}"     
        end
      end
      
            # context of default taxon vary in request_fullpath
      # ex. /cart  context is cart
      #     /user  context is account
      # return :either(detail or list), cart, checkout, register, login
      def current_context
        #TODO verify thanks page.
        case self.request_fullpath
          when /^\/[\d]+\/[\d]+/
            ContextEnum.detail
          when /^\/cart/
            ContextEnum.cart
          when /^\/user/,/^\/password/ 
            ContextEnum.account
          when /^\/account/
            ContextEnum.account 
          when /^\/login/, /^\/checkout\/registration/,/^\/password/
            ContextEnum.login   
          when /^\/signup/
            ContextEnum.signup
          when /^\/checkout/
            ContextEnum.checkout
          when /^\/orders/
            ContextEnum.thanks
          when /^\/signup/
            ContextEnum.signup
          when '/'
            ContextEnum.home
          else
            ContextEnum.list
        end
      end
  
    end
  end
  
end
  