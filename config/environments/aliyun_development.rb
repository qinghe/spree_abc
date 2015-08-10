SpreeAbc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

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

  config.eager_load  = false

  config.spree_multi_site.system_top_domain = 'david.com'

  config.paperclip_defaults= {
    storage: :aliyun,
    aliyun: {
      access_id: ENV['ALIYUN_ACCESS_ID'] ,
      access_key: ENV['ALIYUN_ACCESS_KEY'] ,
      # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
      bucket: 'aliimg' ,
      # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
      internal: false ,
      # 配置存储的地区数据中心，默认: hangzhou
      data_centre: 'beijing',
      # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
      # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
      oss_host: "http://aliimg.firecart.cn",  # aliyun oss host
      img_host: "http://aliimg2.firecart.cn"  # aliyun image service host
      # 如果有需要，你可以自己定义上传 host, 比如阿里内部的上传地址和 Aliyun OSS 对外的不同，可以在这里定义，没有需要可以不用配置
      #upload_host: "http://you_bucket_name.oss.aliyun-inc.com"
    }
  }
end
