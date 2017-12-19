object @image
attributes *image_attributes
attributes :viewable_type, :viewable_id
#当paperclip使用aliyun存储时， styles为空，但是‘产品分类’需要产品图片路径small_url
#所以重载spree页面替换如下代码
#Spree::Image.attachment_definitions[:attachment][:styles].each do |k, _v|
[:mini,:small,:product,:medium,:large].each{|k|
  node("#{k}_url") { |i| i.attachment.url(k) }
}
