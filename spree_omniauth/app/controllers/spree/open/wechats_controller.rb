module Spree::Open
  class WechatsController < ActionController::Base
    # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#rails-responder-controller-dsl
    wechat_responder
    prepend_before_action :initialize_account
    helper_method :wechat_oauth2
    #include Wechat::Responder
    #self.wechat_cfg_account = opts[:account].present? ? opts[:account].to_sym : :default
    #self.wechat_api_client = load_controller_wechat(wechat_cfg_account, opts)

    on :text do |request, content|
      request.reply.text "echo: #{content}" # Just echo
    end


    def callback
      # 1. 寻找用户 uid + provider
      # 2. 如果他没有那么创造和记录用户在O _码数据
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = Spree::User.from_omniauth(request.env["omniauth.auth"]||{})

      if @user
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.wechat_data"] = request.env["omniauth.auth"]
        redirect_to spree.signup_path
      end
    end

    private
    def initialize_account
      #self.wechat_api_client = load_controller_wechat(wechat_cfg_account, opts)
    end
  end

end
