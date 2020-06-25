SpreeAbc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  config.eager_load = false

  config.spree_multi_site.system_top_domain = 'test.host'
  #config.paperclip_defaults= {
  #  storage: :aliyun,
  #  aliyun: {
  #    access_id: ENV['OSS_ACCESS_ID'] ,
  #    access_key: ENV['OSS_ACCESS_SECRET'] ,
  #    # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
  #    bucket: 'otest' ,
  #    # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
  #    internal: false ,
  #    # 配置存储的地区数据中心，默认: hangzhou
  #    data_centre: 'beijing'
  #    # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  #    # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  #    #config.aliyun_host       = "http://foo.bar.com"
  #    # 如果有需要，你可以自己定义上传 host, 比如阿里内部的上传地址和 Aliyun OSS 对外的不同，可以在这里定义，没有需要可以不用配置
  #    # config.aliyun_upload_host = "http://you_bucket_name.oss.aliyun-inc.com"
  #  }
  #}
end
