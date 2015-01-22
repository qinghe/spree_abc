module Spree
  module BaseHelper
    #include SpreeTheme::TemplateBaseHelper
    #==================================================================================================
    # template methods, using by template
    #==================================================================================================
    #these methos has to be in BaseHelpler, controller may be TemplateThemes Cart Checkout User Order..
    #override original in BaseHelper
    def breadcrumbs(current_page_tag, separator="&nbsp;&raquo;&nbsp;")
      # current_page_tag is nil in page /unauthorized
      return "" if current_page?("/") || current_page_tag.nil? ||current_page_tag.page_home?
      separator = raw(separator)
      crumbs = [content_tag(:li, link_to(Spree.t(:home), spree.root_path) + separator)]
      if current_page_tag
        #crumbs << content_tag(:li, link_to(Spree.t(:products), products_path) + separator)
        crumbs << current_page_tag.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , (ancestor.path)) + separator) } unless current_page_tag.ancestors.empty?
        crumbs << content_tag(:li, content_tag(:span, link_to(current_page_tag.name , current_page_tag.path)))          
      end
      crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), class: 'inline')
      content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'sixteen columns')
    end
    
    def link_to_product_thumbnail( current_piece, i )
      link_to( image_tag(i.attachment.url( current_piece.get_content_param_by_key(:thumbnail_style))), 
                         i.attachment.url( current_piece.get_content_param_by_key(:main_image_style))
                         )      
    end
    
    def product_main_image( current_piece, product )
      Spree::MultiSiteSystem.with_context_site_product_images{
        main_image_style = current_piece.get_content_param_by_key(:main_image_style)
        send("#{main_image_style}_image", product, :itemprop => "image")
      }
    end
    
    # override resource path, add taxon into path
    def product_path( product )
      "/0/#{product.id}"
    end
    
    
    def menu_item_atom( current_piece, page )
      leaves_content = ""
      
      unless page.leaf? 
        leaves_content = content_tag(:ul, raw( page.children.map{|child| menu_item_atom( current_piece, child )}.join ) )
      end
      
      piece_selector = current_piece.piece_selector
      item_content = content_tag(:span, page.name, class: 'name' )
            
      item_content=  if page.clickable? 
           if page.current?
             link_to item_content, page.path, page.extra_html_attributes.merge( {:id=>"pi#{piece_selector}_page.id", :class=>"selected depth#{page.depth}"} )
           else
             link_to item_content, page.path, page.extra_html_attributes.merge( {:id=>"pi#{piece_selector}_page.id", :class=>"depth#{page.depth}"} )
           end 
        else
          link_to item_content, page.path, page.extra_html_attributes.merge( {:id=>"pi#{piece_selector}_page.id", :class=>"noclick depth#{page.depth}", :href=>'javascript:void(0)'} )
        end
        
      content_tag(:li,  raw( item_content+ leaves_content ), class: piece_selector ) 
    end
    
    
    # a container could has
    def get_container_class( current_piece )
      css_classes = current_piece.piece_selector + ' ' + current_piece.as_child_selector + ' ' + current_piece.effects.join(' ')
      # how many columns are there?
      # handling data iteration?
      # Rails.logger.debug "current_piece=#{current_piece.id},#{current_piece.title}, current_piece.is_container?=#{current_piece.is_container?}, current_piece.template.running_data_sources.present?=#{current_piece.template.running_data_sources.present?}"
      if current_piece.is_container?
        if current_piece.template.running_data_sources.present?
          column_count = current_piece.template.running_data_source_sction_piece.view_column_count        
          i = current_piece.template.running_data_item_index
          #Rails.logger.debug "i=#{i}, column_count=#{column_count}, current_piece.template.running_data_source_sction_piece=#{current_piece.template.running_data_source_sction_piece.id}" 
          css_classes << ' data_first' if column_count>0 && i==0
          css_classes << ' data_last'  if column_count>0 && ((i+1)%column_count==0)
          css_classes << " data_#{i+1}"
        end                  
      end
      if current_piece.parent.effects.present?
        css_classes << " child_#{current_piece.nth_of_siblings}"
      end
      
      css_classes      
    end
    
    def get_menu_items( current_piece )      
      # for feature hmenu show descendants of current page
      # we should check :page first.
      running_data_item = current_piece.template.running_data_item
      if running_data_item.is_a? PageTag::Menus::WrappedMenu
        running_data_item.children
      else
        current_piece.template.menu.try(:children) || []  
      end      
    end
                    
    #==================================================================================================
    # Editor methods
    #==================================================================================================
    
    def my_remote_function(options)
      full_query_path = options[:query_path]+"?"+options[:query_params].to_param 
      form =  options[:submit]
      confirm_function =  options[:confirm]
      callback = nil
  #    callback = %q! function (data, textStatus, xhr){ $("#editors").html(xhr.responseText); }!
      function = " ajax_post('#{full_query_path}','#{form}','script');return false;"
      if confirm_function.present?
        function = "if(confirm_function){#{function}}"
      end
      function
    end
    # for speed up partial, create these helpers instead of partial
    
    def partial_editor( editor, param_values)
      #local_params: editor, param_values
      @param_category_ids = []      
      <<-EOS
        <div id="editor_#{editor.id}" class="block param_value_editor">
          #{ param_values.collect{|param_value| partial_param_value( param_value )}.join }
        </div>
      EOS
    end
    
    def partial_param_value( param_value)      
      #params:  html_attribute_hash  {id=>html_attribute}
      #         
      #local_params: param_value, param_category
      param_category = param_value.section_param.section_piece_param.param_category
      section_piece_param = param_value.section_param.section_piece_param
      ha_array = param_value.section_param.html_attributes # excluded disabled by section      
      tags = ''
      unless @param_category_ids.include? param_category.id
        @param_category_ids << param_category.id
        tags = %Q( <div class="editor-header">H:#{param_category.slug}</div> )
      end

      ha_array.collect{|html_attribute| 
        tags <<  partial_html_attribute_value( param_value, html_attribute )
      }
      tags
    end

    def partial_html_attribute_value( param_value, html_attribute )
      #params: @theme
      #local params:   html_attribute, param_value
      bool_true = Spree::HtmlAttribute::BOOL_TRUE
      bool_false = Spree::HtmlAttribute::BOOL_FALSE
      section_piece_param = param_value.section_param.section_piece_param
      ha = html_attribute
      pv_div_id = "pv_#{param_value.id}_#{ha.id}"
      pv_ele_id = "pv#{param_value.id}[#{ha.id}]"
      pv_link_id = pv_div_id+'_a'
      hav = Spree::HtmlAttributeValue.parse_from(param_value, ha)
      display = ( hav.hidden? ? "display:none" : ""  )
      query_path = update_param_value_template_theme_path( @theme )
      tags = ""
      ha.repeats.times{ |i|
        psvalue, pvalue,unit = hav["psvalue#{i}"],hav["pvalue#{i}"],hav["unit#{i}"]
        possible_values = ha.possible_selected_values(i)
        possible_values_descriptions = ha.possible_selected_values_descriptions(i)
        units = ha.units
        onchange = my_remote_function( :submit=>"layout_editor_form",:query_path=>query_path, :query_params => hav.build_url_params(:psv_changed), :if=>'')        
        element_style = "display:none;"
        if ha.manual_entry?(psvalue)
          element_style="display:inline-block;"
        end
        manual_value_onchange = my_remote_function( :submit=>"layout_editor_form",:query_path=>query_path, :query_params => hav.build_url_params(:pv_changed))
        passible_value_tag = ""
        manual_value_tag = ""
        manual_unit_tag = ""
        if possible_values.size>1
          passible_value_tag << select(pv_ele_id,"psvalue#{i}", possible_values.each_index.collect{|j|  [possible_values_descriptions[j],possible_values[j]] },{:selected =>psvalue }, {:class=>"pv-psv", :onchange=>onchange})
        else
          passible_value_tag << hidden_field_tag("#{pv_ele_id}[psvalue#{i}]", psvalue )
        end
        
        if html_attribute.is_special?(:bool)
          manual_value_tag << radio_button_tag("#{pv_ele_id}[pvalue#{i}]", bool_true,pvalue==bool_true, :onchange=>manual_value_onchange )+"Yes" 
          manual_value_tag << radio_button_tag("#{pv_ele_id}[pvalue#{i}]", bool_false,pvalue==bool_false, :onchange=>manual_value_onchange )+"No"
        elsif html_attribute.is_special?(:image)
          manual_value_tag << select("#{pv_ele_id}","pvalue#{i}", Spree::TemplateFile.all.collect{|item| [item.attachment_file_name, item.attachment_file_name]}, {:selected=>pvalue ,:include_blank=>"Please select "},{ :onchange=>manual_value_onchange}) 
          manual_value_tag << link_to( "upload file...",{:controller=>"spree/template_themes", :action=>"upload_file_dialog",:param_value_id=>param_value.id, :html_attribute_id=>html_attribute.id, :selected_editor_id=>@editor.id},:method =>:get,:remote=>true )  
        else
          manual_value_tag << text_field_tag("#{pv_ele_id}[pvalue#{i}]", pvalue, {:class=>"pv-pv",  :onchange=>manual_value_onchange})
        end
        if units        
          manual_unit_tag << select(pv_ele_id,"unit#{i}", units.collect{|psv|  [psv, psv] },{:selected => unit}, {:class=>"pv-psv", :style=>element_style, :onchange=>manual_value_onchange}) 
        end         
        tags.concat <<-EOS1                
          <div class="clear-block">
            <div class="fl"> #{passible_value_tag} </div>
            <div class="fl" style="#{element_style}">   #{manual_value_tag} </div>
            <div class="fl"> #{manual_unit_tag} </div>
          </div>
        EOS1
      }
      unset_tag = ""
      unset_onchange = my_remote_function( :submit=>"layout_editor_form",:query_path=>query_path, :query_params => hav.build_url_params(:unset_changed))
      unset_tag<<  check_box_tag(pv_ele_id+"[unset]", bool_true, hav.unset?, :onchange=>unset_onchange)
      unset_tag<<  label_tag(pv_ele_id+"[unset]", "Unset")

      <<-EOS2
        <div id="#{pv_div_id}" class="pv clear-block" style="#{display}">
          <div class="fl"> <span class="pv-name">#{ha.title}</span>
          </div>
          <div class="fl" style="#{'display:none' if hav.unset?}">
            #{tags}                  
          </div>
          <div class="fr"> #{unset_tag} </div>
        </div>
      EOS2
    end
    
  end
end