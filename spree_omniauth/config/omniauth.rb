Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :open_wechat, ENV['OPEN_WECHAT_KEY'], ENV['OPEN_WECHAT_SECRET'], :scope => 'snsapi_login'

  on_failure { |env| AuthenticationsController.action(:failure).call(env) }

end
