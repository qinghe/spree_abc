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
    end
    
    module ClassMethods
      def default_scope  
        # admin_site_product: create,update
        if self == Spree::Taxon  && multi_site_context=='admin_site_product'
          scoped 
        elsif self == Spree::Product  && multi_site_context=='site1_themes'
          scoped 
        else  
          where(:site_id =>  Spree::Site.current.id)
        end 
      end  
      # remove it after upgrade to rails 4.0
      def multi_site_context
        MultiSiteSystem.multi_site_context
      end          
    end
 
    def self.setup_context(  new_multi_site_context = nil)
      self.multi_site_context = new_multi_site_context
    end
      
  end
end