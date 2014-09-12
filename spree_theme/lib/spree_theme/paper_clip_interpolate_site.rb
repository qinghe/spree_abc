unless Paperclip::Interpolations.all.include? :site
  Paperclip.interpolates :site do |attachment, style_name|
    SpreeTheme.site_class.current.id
  end
end