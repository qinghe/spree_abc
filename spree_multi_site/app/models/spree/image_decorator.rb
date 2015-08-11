Spree::Image.class_eval do
  #override attachement[:path]
  attachment_definitions[:attachment][:url] = '/shops/:rails_env/:site/products/:id/:basename_:style.:extension'
  attachment_definitions[:attachment][:path] = ':rails_root/public/shops/:rails_env/:site/products/:id/:basename_:style.:extension'
  attachment_definitions[:attachment][:styles] = { mini: '48x48>', small: '100x100>', product: '240x240>', medium: '350x350>', large: '600x600>' }

  extend SpreeMultiSite::PaperclipAliyunOssHelper

end

Spree::Taxon.class_eval do
  #override attachement[:path]
  attachment_definitions[:icon][:url] = '/shops/:rails_env/:site/taxons/:id/:style/:basename.:extension'
  attachment_definitions[:icon][:path] = ':rails_root/public/shops/:rails_env/:site/taxons/:id/:style/:basename.:extension'

  extend SpreeMultiSite::PaperclipAliyunOssHelper
end

Spree::Post.class_eval do
  #override attachement[:path]
  attachment_definitions[:cover][:url] = '/shops/:rails_env/:site/posts/:id/:basename_:style.:extension'
  attachment_definitions[:cover][:path] = ':rails_root/public/shops/:rails_env/:site/posts/:id/:basename_:style.:extension'

  extend SpreeMultiSite::PaperclipAliyunOssHelper
end

Spree::TemplateFile.class_eval do
  attachment_definitions[:attachment][:url] = "/shops/:rails_env/:site/:class/:id/:basename_:style.:extension"
  attachment_definitions[:attachment][:path] = ":rails_root/public/shops/:rails_env/:site/:class/:id/:basename_:style.:extension"

  extend SpreeMultiSite::PaperclipAliyunOssHelper
end

#Rails.application.config.spree_multi_site.site_scope_required_classes_with_image_from_other_gems.each do |attachement_name_symbol, extra_class|
#  extra_class.class_eval do
#    include Spree::MultiSiteSystem
#  end
#  # Spree::Post => 'posts'  class.to_s.demodulize.underscore.pluralize
#  extra_class.attachment_definitions[attachement_name_symbol][:url] = "/shops/:rails_env/:site/:class/:id/:style/:basename.:extension"
#  extra_class.attachment_definitions[attachement_name_symbol][:path] = ':rails_root/public/shops/:rails_env/:site/:class/:id/:style/:basename.:extension'
#end
