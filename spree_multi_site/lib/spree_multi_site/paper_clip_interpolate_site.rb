Paperclip.interpolates :site do |attachment, style_name|
  Spree::Site.current.id
end