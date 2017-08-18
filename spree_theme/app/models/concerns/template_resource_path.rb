  module TemplateResourcePath

    def build_path( taxon=nil )

        case self
          when SpreeTheme.taxon_class
            build_taxon_path
          when Spree::Product
            build_product_path(taxon)
          when SpreeTheme.post_class
            build_post_path(taxon)
        end

    end


    #taxon
    def build_taxon_path
      # consider extra_html_attributes first
      # self.id, self.slug would be nil if it is class DefaultTaxon
      self.extra_html_attributes.try(:[],:href) || context_routes[current_context] || "/#{self.id.to_i}-#{self.permalink.to_s.split('/').last}"
    end

    #product
    def build_product_path(taxon)
Rails.logger.debug "build_product_path taxon = #{taxon.id}, partial_path=#{taxon.partial_path} "      
      taxon.partial_path + "/#{self.id}-#{self.friendly_id}"
    end

    #post
    def build_post_path(taxon)
      "/post"+ taxon.partial_path + "/#{self.id}-#{self.friendly_id}"
    end

    # taxon partial path
    def partial_path
      # menu.id would be nil if it is class DefaultTaxon
      if( self.persisted? && !self.home? )
        build_taxon_path
      else
        # 1. in case default home page show all products,
        # 2. prevent '//10-cup', it is required
        "/#{self.id.to_i}"
      end
    end

    #https://github.com/spree-contrib/spree_sitemap/blob/master/lib/spree_sitemap/spree_defaults.rb
    #def add_login(options = {})
    #  add(login_path, options)
    #end

    #def add_signup(options = {})
    #  add(signup_path, options)
    #end

    #def add_account(options = {})
    #  add(account_path, options)
    #end

    #def add_password_reset(options = {})
    #  add(new_spree_user_password_path, options)
    #end
  end
