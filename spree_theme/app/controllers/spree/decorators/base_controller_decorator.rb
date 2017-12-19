#encoding: utf-8
Spree::BaseController.class_eval do
    prepend_before_action :set_multi_site_scope
    def set_multi_site_scope
      Spree::MultiSiteSystem.bind
    end
end

Spree::Api::BaseController.class_eval do
    prepend_before_action :set_multi_site_scope
    def set_multi_site_scope
      Spree::MultiSiteSystem.bind
    end
end

module Spree::Admin
  BaseController.class_eval do
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to  admin_login_path
    end
  end
end
