SpreeAbc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  config.eager_load  = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.getstore.cn',
    port:                 25,
    user_name:            'notice@getstore.cn',
    password:              ENV['NOTICE_AT_GETSTORE'],
    authentication:       'login',
    openssl_verify_mode: 'none',
    enable_starttls_auto: false
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.show_previews = true
  # ExceptionNotification is using ActionMailer::Base as mailer,
  # it is using above smtp_setting,
  # spree_mail_settings is using Spree::BaseMailer,
  config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[LocalException] ",
      :sender_address => %{"info" <notice@getstore.cn>},
      :exception_recipients => %w{admin@getstore.cn}
    }

  config.spree_multi_site.system_top_domain = 'david.com'
end
