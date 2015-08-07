Paperclip.options[:command_path] = "/usr/local/bin/"

Paperclip::Attachment.default_options[:aliyun] = {
  config.aliyun_access_id  = "xxxxxx"
  config.aliyun_access_key = 'xxxxxx'
  # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
  config.aliyun_bucket     = "getstore"
  # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
  config.aliyun_internal   = false
  # 配置存储的地区数据中心，默认: cn-hangzhou
  # config.aliyun_area     = "cn-hangzhou"
  # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  #config.aliyun_host       = "http://foo.bar.com"
  # 如果有需要，你可以自己定义上传 host, 比如阿里内部的上传地址和 Aliyun OSS 对外的不同，可以在这里定义，没有需要可以不用配置
  # config.aliyun_upload_host = "http://you_bucket_name.oss.aliyun-inc.com"
}
