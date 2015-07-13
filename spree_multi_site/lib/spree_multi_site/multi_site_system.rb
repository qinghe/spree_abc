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
    extend ActiveSupport::Concern
    mattr_accessor :multi_site_context
    
    included do
      belongs_to :site
      # rails 3.2.19
      # fix: Spree::Taxon.create!({ taxonomy_id: 0, name: 'name' }, without_protection: true) =>
      # <Spree::Taxon id: 30, name: "name", taxonomy_id: 0, site_id: nil,  depth: 0, page_context: 0, html_attributes: nil, replaced_by: 0> 
      before_create {|record| record.site_id||= Spree::Site.current.id }   
      
      default_scope {
        # admin_site_product, create or update global taxon.
        if self == Spree::Taxon  && multi_site_context=='admin_site_product'
          scoped 
        # first site list template themes 
        elsif self == Spree::Product  && multi_site_context=='site1_themes'
          scoped 
        # first site list product images  
        elsif self == Spree::Image && multi_site_context=='site_product_images'
          scoped           
        elsif multi_site_context=='admin_migration'
          scoped           
        else  
          where(:site_id =>  Spree::Site.current.id)
        end      
      }
         
    end
    
    module ClassMethods
      # remove it after upgrade to rails 4.0
      def multi_site_context
        MultiSiteSystem.multi_site_context
      end          
    end
 
    def self.setup_context(  new_multi_site_context = nil)
      self.multi_site_context = new_multi_site_context
    end
    
    # do block with given context
    def self.with_context( new_context, &block )
      original_context = self.multi_site_context
      begin
        self.multi_site_context = new_context
        yield
      ensure
        self.multi_site_context = original_context
      end
    end
    
    def self.with_context_admin_site_product(&block)
      with_context( 'admin_site_product', &block )
    end

    def self.with_context_site1_themes(&block)
      with_context( 'site1_themes', &block )
    end
    def self.with_context_site_product_images(&block)
      with_context( 'site_product_images', &block )
    end
    
  end
end