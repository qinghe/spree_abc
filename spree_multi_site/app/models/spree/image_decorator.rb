Spree::Image.class_eval do
#override attachement[:path]      
  Spree::Image.attachment_definitions[:attachment][:url] = '/shops/:rails_env/:site/products/:id/:basename_:style.:extension'
  Spree::Image.attachment_definitions[:attachment][:path] = ':rails_root/public/shops/:rails_env/:site/products/:id/:basename_:style.:extension'
end

Spree::Taxon.class_eval do
  #override attachement[:path]      
  attachment_definitions[:icon][:url] = '/shops/:rails_env/:site/taxons/:id/:style/:basename.:extension'
  attachment_definitions[:icon][:path] = ':rails_root/public/shops/:rails_env/:site/taxons/:id/:style/:basename.:extension'
end

#Spree::Post.class_eval do
#  #override attachement[:path]      
#  attachment_definitions[:cover][:url] = '/shops/:rails_env/:site/posts/:id/:style/:basename.:extension'
#  attachment_definitions[:cover][:path] = ':rails_root/public/shops/:rails_env/:site/posts/:id/:style/:basename.:extension'
#end

Rails.application.config.spree_multi_site.site_scope_required_classes_with_image_from_other_gems.each do |attachement_name_symbol, extra_class|
  extra_class.class_eval do
    include Spree::MultiSiteSystem
    # Spree::Post => 'posts'
    attachment_definitions[attachement_name_symbol][:url] = "/shops/:rails_env/:site/#{extra_class.to_s.demodulize.underscore.pluralize}/:id/:style/:basename.:extension"
    attachment_definitions[attachement_name_symbol][:path] = ':rails_root/public/shops/:rails_env/:site/#{extra_class.to_s.demodulize.underscore.pluralize}/:id/:style/:basename.:extension'

  end  
end
