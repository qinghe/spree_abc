module PageTag
  #get attributes from current datasource
  class PostAttribute < ModelAttribute
    alias_attribute :wrapped_post, :wrapped_model

    def get( attribute_name )
        attribute_value = case attribute_name
          when :cover
            style = self.current_piece.get_content_param_by_key(:main_image_style)
            if wrapped_post.cover.present?
              tag('img', :src=>wrapped_post.cover.url(style), :u=>'image', :alt=>'post image', :class=>"img-responsive" )
            else
              image_tag "noimage/post_#{style}.png", { :alt=>'missing image', :class=>"img-responsive" }
            end
          when :file
            post_file.attachment_file_name if post_file
          when :summary
            wrapped_post.send attribute_name, self.current_piece.truncate_at
          when :detail
            #get more text from page.html_attributes[:title] || Spree.t('more')
            this.options.delete(:detail_text) || Spree.t(:detail)
          else
            wrapped_post.send attribute_name
          end

        if self.current_piece.clickable?
          html_options = { href: wrapped_post.path }
          if attribute_name == :summary
            attribute_value + content_tag(:a, "[#{Spree.t(:detail)}]", html_options)
          elsif attribute_name == :file
            #file is downloadable
            content_tag(:a, post_file.alt.present? ? post_file.alt : wrapped_post.title, { href: post_file.attachment.url, title: attribute_value })
          else
            content_tag(:a, attribute_value, html_options)
          end
        elsif attribute_name == :title
          # make it as link anchor
          content_tag :span, attribute_value, {:id=>"p_#{self.current_piece.id}_#{wrapped_post.id}"}
        elsif attribute_name == :posted_at
          case self.current_piece.datetime_style
            when :date
              pretty_date attribute_value
            when :simple_date
              pretty_date attribute_value, :simple_date
            else
              pretty_datetime attribute_value
          end
        else
          attribute_value
        end

    end


    def post_file
      options[:file] || wrapped_post.files.first
    end

  end
end
