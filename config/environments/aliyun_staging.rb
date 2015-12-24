SpreeAbc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :memory_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = "http://aliasscdn.getstore.cn"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.show_previews = false
  # use delivery_method :spree which added by spree_mail_settings
  config.action_mailer.delivery_method = :spree
  # add smtp_settings as default options
  config.action_mailer.smtp_settings = {
    address:              'smtp.getstore.cn',
    port:                 25,
    user_name:            'notice@getstore.cn',
    password:              ENV['NOTICE_AT_GETSTORE'],
    authentication:       'login',
    openssl_verify_mode: 'none',
    enable_starttls_auto: false
  }

  config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[GetStoreException] ",
      :sender_address => %{"notice" <notice@getstore.cn>},
      :exception_recipients => %w{admin@getstore.cn}
    }
  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.eager_load = true

  config.paperclip_defaults= {
    storage: :aliyun,
    aliyun: {
      access_id: ENV['OSS_ACCESS_ID'] ,
      access_key: ENV['OSS_ACCESS_SECRET'] ,
      # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
      bucket: 'aliimg' ,
      # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
      internal: false ,
      # 配置存储的地区数据中心，默认: hangzhou
      data_centre: 'beijing',
      # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
      # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
      oss_host: "aliimg.getstore.cn",  # aliyun oss host
      img_host: "aliimg2.getstore.cn",  # aliyun image service host
      # 如果有需要，你可以自己定义上传 host, 比如阿里内部的上传地址和 Aliyun OSS 对外的不同，可以在这里定义，没有需要可以不用配置
      upload_host: "aliimg.oss-cn-beijing-internal.aliyuncs.com"
    }
  }
  config.spree_multi_site.system_top_domain = 'getstore.cn'
end
Paperclip.options[:command_path] = "/usr/local/bin/"
