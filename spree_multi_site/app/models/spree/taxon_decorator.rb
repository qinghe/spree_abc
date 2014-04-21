Spree::Taxon.class_eval do
  #override attachement[:path]      
  attachment_definitions[:icon][:url] = '/shops/:rails_env/:site/taxons/:id/:style/:basename.:extension'
  attachment_definitions[:icon][:path] = ':rails_root/public/shops/:rails_env/:site/taxons/:id/:style/:basename.:extension'
end