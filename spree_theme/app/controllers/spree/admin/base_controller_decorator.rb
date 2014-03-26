#encoding: utf-8
module Spree
  module Admin
    BaseController.class_eval do
      rescue_from CanCan::AccessDenied do |exception|
        return spree_theme_admin_unauthorized
      end  
      
      def spree_theme_admin_unauthorized
          if try_spree_current_user
            flash[:error] = Spree.t(:authorization_failure)
            redirect_to '/unauthorized'
          else
            store_location
            url = new_admin_session_path
            redirect_to url
          end
      end  
    end
  end
end