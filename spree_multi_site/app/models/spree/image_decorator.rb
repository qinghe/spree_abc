Spree::Image.class_eval do
#override attachement[:path]      
  Spree::Image.attachment_definitions[:attachment][:url] = '/spree/:site/products/:id/:basename_:style.:extension'

  Spree::Image.attachment_definitions[:attachment][:path] = ':rails_root/public/spree/:site/products/:id/:basename_:style.:extension'

end