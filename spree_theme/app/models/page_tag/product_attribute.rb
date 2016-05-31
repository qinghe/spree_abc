module PageTag
  #get attributes from current datasource
  class ProductAttribute < ModelAttribute
    alias_attribute :wrapped_product, :wrapped_model

    def get( attribute_name )
      attribute_value = case attribute_name
        when :name
            # make it as link anchor
            content_tag :span, wrapped_product.name, {:id=>"p_#{self.current_piece.id}_#{wrapped_product.id}"}
        when :image
            product_image( wrapped_product, options[:image] )
        when :thumbnail
            i = options[:image]
            content_tag(:a, create_product_image_tag( i, wrapped_product, {}, current_piece.get_content_param_by_key(:thumbnail_style)),
                         { href: i.attachment.url( current_piece.get_content_param_by_key(:main_image_style)) }
                         )
        when :icon_angle_right
           '>'
        when :icon_angle_left
           '<'
        else
            wrapped_product.send attribute_name
        end
        if attribute_name== :image && self.current_piece.is_zoomable_image?
          # main image
          # wrap with a, image-zoom required
          # content_tag(:a, attribute_value, { class: 'image-zoom' })
          attribute_value
        elsif self.current_piece.clickable?
          content_tag(:a, attribute_value, { href: wrapped_product.path })
        else
          attribute_value
        end
    end

    # get image ignore current_piece
    def simple_image(style)
      product_image_by_spree( wrapped_product.model, style )
    end

    private
    def create_product_image_tag( image, product, options, style)
      #Rails.logger.debug " image = #{image} product = #{product}, options= #{options}, style=#{style}"
      options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt
      # data-big-image for jqzoom, large=600x600
      options.merge!  'data' => { 'big-image'=> image.attachment.url(:large) }
      image_tag( image.attachment.url(style), options )
    end
    # copy from BaseHelper#define_image_method
    def product_image_by_spree(product, style, options = {})
        if product.images.empty?
          if !product.is_a?(Spree::Variant) && !product.variant_images.empty?
            create_product_image_tag(product.variant_images.first, product, options, style)
          else
            if product.is_a?(Spree::Variant) && !product.product.variant_images.empty?
              create_product_image_tag(product.product.variant_images.first, product, options, style)
            else
              #seems assets digest do not support template .ruby
              #image_tag "noimage/#{style}.png", options
              options.merge!  'data' => { 'big-image'=> "noimage/large.png" } #zoomable required
              image_tag "noimage/#{style}.png", options
            end
          end
        else
          create_product_image_tag(product.images.first, product, options, style)
        end
    end

    # * params
    #   * options - available keys for image_tag
    #   * specified_image - show this image
    def product_image(wrapped_product, specified_image = nil, options = {})
      product = wrapped_product.model
      #Spree::MultiSiteSystem.with_context_site_product_images{
        main_image_style = current_piece.get_content_param_by_key(:main_image_style)
        main_image_position = current_piece.get_content_param_by_key(:main_image_position)
        options.merge! itemprop: "image"
        # only main image have title 'click to get lightbox'
        if current_piece.lightboxable?
          options.merge!  title: I18n.t( "theme.product_image.lightboxable")
        end

        if specified_image
          # mainly for feature product image slider
          create_product_image_tag( specified_image, product, options, main_image_style)
        elsif main_image_position>0
          if product.images[main_image_position].present?
            create_product_image_tag(product.images[main_image_position], product, options, main_image_style)
          end
        else
          product_image_by_spree( product, main_image_style, options)
        end
      #}
    end

  end
end
