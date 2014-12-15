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

Spree::Post.class_eval do
  #override attachement[:path]      
  attachment_definitions[:cover][:url] = '/shops/:rails_env/:site/posts/:id/:style/:basename.:extension'
  attachment_definitions[:cover][:path] = ':rails_root/public/shops/:rails_env/:site/posts/:id/:style/:basename.:extension'
end