require 'spree/core/controller_helpers/common'
# spree/api/base>action_base, spree/base>application
# both included controller_helper/store
class << Spree::Core::ControllerHelpers::Common
  def included_with_omniauth_support(receiver)
    included_without_omniauth_support(receiver)
    receiver.send :include, SpreeOmniauth::System
    receiver.send :wechat_api
    receiver.send :prepend_before_action, :initialize_wechat_account
    receiver.send :helper_method, :wechat_oauth2_url

  end
  alias_method_chain :included, :omniauth_support
end

module SpreeOmniauth
  module System
    def wechat_oauth2_url
      oauth2_params = {
        appid: Spree::Store.current.wx_appid,
        redirect_uri: spree.open_wechat_callback_path,
        scope: 'snsapi_login',
        response_type: 'code'
      }
      generate_oauth2_url(oauth2_params)
    end

    private
    def initialize_wechat_account
      Rails.logger.debug "initialize_wechat_account"
      #self.wechat_api_client = load_controller_wechat(wechat_cfg_account, opts)
    end
  end
end
