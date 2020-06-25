module PageTag
  #get attributes from current datasource
  class PageAttribute < ModelAttribute
    alias_attribute :wrapped_page, :wrapped_model

    def get( attribute_name )
      attribute_value = case attribute_name
        when :icon
          if wrapped_page.icon.present?
            tag('img', :src=>wrapped_page.icon.attachment.url(:original), :u=>'image', :alt=>wrapped_page.name, :class=>"img-responsive" )
          else
            ''
          end
        when :summary
          wrapped_page.send attribute_name, self.current_piece.truncate_at
        when :more # it is same as clickable wrapped_page name
          #get more text from page.html_attributes[:title] || Spree.t('more')
          Spree.t('more')
        when :root_name
          wrapped_page.name
        when :root_tooltips
          wrapped_page.tooltips
        when :icon_angle_right
           '>'
        when :icon_angle_left
           '<'
        when :placeholder # get text from current_piece.alternative_text
          self.options.delete(:attribute_placeholder) || Spree.t(:placeholder)
        else
          wrapped_page.send attribute_name
      end
      if self.current_piece.clickable? || attribute_name==:more
        html_options = wrapped_page.extra_html_attributes
        html_options[:href] ||= wrapped_page.path
        html_options[:class] ||= 'selected' if wrapped_page.current?
        if attribute_name == :summary
          attribute_value << content_tag(:a, "[#{Spree.t(:detail)}]", html_options)
        else
          if wrapped_page.clickable?
            content_tag(:a, attribute_value, html_options)
          else
            attribute_value
          end
        end
      elsif attribute_name==:name
        # make it as link anchor,  wrapped with span, css text-* applicable
        content_tag :span, attribute_value, {:id=>"p_#{self.current_piece.id}_#{wrapped_page.id}"}
      else
        attribute_value
      end

    end


  end
end
