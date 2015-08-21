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
          ContextEnum.logout =>"/logout",
          ContextEnum.checkout =>"/checkout",
          ContextEnum.cart =>"/cart",
          ContextEnum.signup =>"/signup",
          ContextEnum.login =>"/login",
          ContextEnum.either =>"/" #default_taxon for context :either is home
          }
        scope :homes, ->{ where(:page_context=> 1 )}
        #FIXME what if home is not assigned to theme?
        def self.home
          homes.first
        end

        # context is symbol
        def self.get_route_by_context( some_context )
          context_routes[ some_context ] || context_routes[ ContextEnum.either ]
        end

        # page context is integer
        def self.get_route_by_page_context( page_context )
          #convert to symbol context first
          get_route_by_context( get_context_by_page_context( page_context ) )
        end

        def self.get_context_by_page_context( target_page_context )
            case target_page_context
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
              when 8
                ContextEnum.blog
              else
                ContextEnum.list
            end
        end

        def path
          # self.id, self.permalink would be nil if it is class DefaultTaxon
          context_routes[current_context] || "/#{self.id.to_i}-#{self.permalink.to_s.split('/').last}"
        end
      end

      # context of default taxon vary in request_fullpath
      # ex. /cart  context is cart
      #     /user  context is account
      # return :either(detail or list), cart, checkout, register, login
      def current_context
        # consider query_string d=www.dalianshops.com and preview path /template_themes/2/preview
        @context_context = nil
        if request_fullpath.present? #for current page, request_fullpath is present
          @context_context = get_context_by_full_path( request_fullpath )
        end

        if @context_context.nil?
          target_page_context = ( self.page_context>0 ? self.page_context : inherited_page_context )
          @context_context = self.class.get_context_by_page_context( target_page_context )
        end
        @context_context
      end

      def context_either?
        current_context ==ContextEnum.either
      end

      #is it a home page?
      def page_home?
        page_context == 1
      end

      #support feature
      def inherited_page_context
        root.page_context
        #return page_context if root?
        #ancestors.map(&:page_context).select{|i| i>0 }.last || 0
      end

      def get_context_by_full_path( full_path )
          case full_path
            when /^\/\d[^\/]*\/\d[^\/]*/ #"/3-bags/1-ruby-on-rails-tote"
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
            when /^\/logout/
              ContextEnum.logout
            when '/',/^\/\?/, /^\/template_themes/
              ContextEnum.home
            else
              # it could be blog or list
              nil # we can not identify it just from path
          end
      end

      PageContextEnum = Struct.new(:list, :home, :cart, :account, :signup, :login, :blog)[0, 1, 2, 7, 5, 6, 8]
      PageContextForFirstSiteEnum = Struct.new(:new_site)[20]


    end
  end

end
