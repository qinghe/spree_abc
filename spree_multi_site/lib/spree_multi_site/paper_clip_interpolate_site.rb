unless Paperclip::Interpolations.all.include? :site
  Paperclip.interpolates :site do |attachment, style_name|
    attachment.instance.site_id # site.current do not work anymore, since we assign theme product to taxon of shop1.
  end
  # Paperclip support :class,  Spree::Taxon => spree/taxon, with simple_class, Spree::Taxon => taxon
  Paperclip.interpolates :simple_class do |attachment, style_name|
    attachment.instance.class.to_s.demodulize.underscore
  end

  Paperclip.interpolates :aliyun_host do |attachment, style_name|
    
  end

  # support aliyun image resize service
  # product image { mini: '48x48>', small: '100x100>', product: '240x240>', medium: '350x350>', large: '600x600>' }
  # post image { mini: '60x60>', small: '180x120>', medium: '280x190>', large: '670x370>'},
  # http://userdomain/object.jpg@100w_100h_90Q.jpg
  Paperclip.interpolates :aliyun_style do |attachment, style_name|
    extension = '.jpg'
    style = case style_name
      when :mini
        '@48w_48h_90Q_1x' + extension
      when :small
        '@100w_100h_90Q_1x' + extension
      when :product
        '@240w_240h_90Q_1x' + extension
      when :medium
        '@350w_350h_90Q_1x' + extension
      when :large
        '@600w_600h_90Q_1x' + extension
      when :bmini
        '@60w_60h_90Q_1x' + extension
      when :bsmall
        '@180w_120h_90Q_1x' + extension
      when :bmedium
        '@280w_190h_90Q_1x' + extension
      when :blarge
        '@670w_370h_90Q_1x' + extension
    end
  end

end
