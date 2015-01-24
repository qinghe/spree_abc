module PageEvent
  class ParamValueEvent < ParamValueEventBase
    # it should return updated_html_attribute_values, action collect them and update the editor.  
    def notify(  )
      param_conditions = self.param_value.section_param.section_piece_param.param_conditions
      
      unless param_conditions[self.html_attribute.id].nil?
#        Rails.logger.debug "param_conditions=#{param_conditions.inspect},self.event=#{self.event}"
        #event handler is html_attribute.slug + event + handler      
        if param_conditions[self.html_attribute.id].include?(self.event)
          #html_attribute.slug may contain '-', we only allow a-z,A-Z,0-9,_ by [/\w+/]
          html_page = self.param_value.template_theme.html_page
          html_piece = html_page.partial_htmls.select{|hp| hp.page_layout.id==self.param_value.page_layout_id }.pop
# Rails.logger.debug "self.param_value=#{self.param_value.inspect}"        
# Rails.logger.debug "html_piece=#{html_piece.inspect}"            
          #self.updated_html_attribute_values.concat( )
          self.send( handler_name, html_piece)    
        end      
      end
      self.updated_html_attribute_values
    end
    
    def event_name
      return event
    end
  
    def handler_name
      "#{self.html_attribute.slug[/\w+/]}_#{self.event_name}_handler"
    end
     
    def height_pv_changed_handler(partial_html)
      dimension_changed_handler(partial_html, 'height')
      #height = partial_html.height 
      #if height>0
      #  margin, border, padding = partial_html.margin, partial_html.border, partial_html.padding
      #  val = partial_html.html_attribute_values('inner_height')
      #  inner_height_value = height
      #  [0,2].each{|i|#0:top, 2: bottom
      #    inner_height_value-= margin[i]  
      #    inner_height_value-= border[i]  
      #    inner_height_value-= padding[i]  
      #      } 
      #  hav = partial_html.html_attribute_values("block_height")         
      #  computed_inner_height['psvalue'] = hav['psvalue']
      #  computed_inner_height['pvalue'] = inner_height_value
      #  computed_inner_height['unit'] = hav['unit']
      #  computed_inner_height['unset'] = Spree::HtmlAttribute::BOOL_FALSE
      #  self.updated_html_attribute_values.push(computed_inner_height)
      #else
      #  computed_inner_height = partial_html.html_attribute_values('inner_height')
      #  computed_inner_height['unset'] = Spree::HtmlAttribute::BOOL_TRUE
      #  self.updated_html_attribute_values.push(computed_inner_height)
      #end
    end
    def width_pv_changed_handler(partial_html)
      dimension_changed_handler(partial_html, 'width')
    end
    # compute inner dimension is required by baidu map
    #html_attribute_name could be width, height
    def dimension_changed_handler(partial_html, html_attribute_name)
      trbl = (html_attribute_name == 'width' ? [1,3] : [0,2]) 
      val = partial_html.send(  html_attribute_name )
      if val>0
        margin, border, padding = partial_html.margin, partial_html.border, partial_html.padding
        
        computed_inner = partial_html.html_attribute_values("inner_#{html_attribute_name}")
        inner_value = val
        trbl.each{|i|#0:top, 2: bottom
          inner_value-= margin[i]  
          inner_value-= border[i]  
          inner_value-= padding[i]  
            } 
        hav = partial_html.html_attribute_values("block_#{html_attribute_name}")         
        computed_inner['psvalue'] = hav['psvalue']
        computed_inner['pvalue'] = inner_value
        computed_inner['unit'] = hav['unit']
        computed_inner['unset'] = Spree::HtmlAttribute::BOOL_FALSE
        self.updated_html_attribute_values.push(computed_inner)
      else
        computed_inner = partial_html.html_attribute_values('inner_#{html_attribute_name}')
        computed_inner['unset'] = Spree::HtmlAttribute::BOOL_TRUE
        self.updated_html_attribute_values.push(computed_inner)
      end
    end

    
    # TODO width_pv_changed_handler, should not bigger than its parent's width.
    def border_pv_changed_handler(partial_html)
      height_pv_changed_handler( partial_html )
    end 
    def margin_pv_changed_handler(partial_html)
      height_pv_changed_handler( partial_html )
    end 
    def padding_pv_changed_handler(partial_html)
      height_pv_changed_handler( partial_html )      
    end 

    alias_method :height_unset_changed_handler, :height_pv_changed_handler
    alias_method :border_unset_changed_handler, :height_pv_changed_handler
    alias_method :margin_unset_changed_handler, :height_pv_changed_handler
    alias_method :padding_unset_changed_handler, :height_pv_changed_handler
    
    # here are two tipical layouts,    
    #   Layout Example                                 fluid --> fixed                         fixed --> fluid
    #   layout_root1 
    #         +----center_area
    #         |       +-------center_part
    #         |       |-------header_part
    #         |       |-------left_part
    #         |       +-------right_part    
    #         |----footer   
    #  
    #   layout_root2 
    #         +--page
    #         |    +----center_area
    #         |    |       +-------center_part
    #         |    |       |-------header_part
    #         |    |       |-------left_part
    #         |    |       +-------right_part    
    #         |    +----footer   
    #         +--dialog
    #         +--message_box
    
    # rules to change layout from fixed to fluid
    #  1. it only works for container section.
    #  2. it only works while there are all container section in same level(exclude float section, ex. dialog).
    #  ex. in layout1. center_area and footer are same level,  center_part, header_part, left_part and right_part are same level 
    #  container and content layout is not horizontal, width-> unset
    #  root is also a container
    # rules to change layout from fluid to fixed             
    
    def page_layout_fixed_event_handler( global_param_value_event )
      is_fixed = global_param_value_event.new_html_attribute_value.pvalue
      parent_block_width =  self.parent_section_instance.html_attribute_values("block_width") unless self.parent.nil?    
      block_width = html_attribute_values("block_width")
      block_margin =  html_attribute_values("block_margin")
      block_inner_margin = html_attribute_values("inner_margin")
  
      if is_fixed
        to_fixed()
      else
        to_fluid()
      end
    end
  
    # a container, content layout attribute of parent is vertical, and have a width value, we could say to_fluid means unset the width. 
    def to_fluid()
      if self.root?
        block_min_width = html_attribute_values("page_min-width")
        block_width = html_attribute_values("page_width")
        block_margin =  html_attribute_values("page_margin")
        #block, inner
        
          block_width['unset']  = HtmlAttribute::BOOL_TRUE
          block_width['hidden']  = HtmlAttribute::BOOL_TRUE
          block_min_width['unset']  = HtmlAttribute::BOOL_FALSE
          block_min_width['hidden']  = HtmlAttribute::BOOL_FALSE
        self.updated_html_attribute_values.push(block_width,block_min_width,block_margin )
      elsif self.section.slug=='container'
    
         
      end    
    end
    
  # a container, if have no width value, content layout attribute of ancestors are vertical, to_fixed means change nothing. 
  #              if have width value and bigger than available width, we could say to_fixed means unset the width. 
    def to_fixed()
      if self.root?
        block_min_width = html_attribute_values("page_min-width")
        block_width = html_attribute_values("page_width")
        block_margin =  html_attribute_values("page_margin")
        #block, inner
          block_width['unset']  = HtmlAttribute::BOOL_FALSE
          block_width['hidden']  = HtmlAttribute::BOOL_FALSE
          block_min_width['unset']  = HtmlAttribute::BOOL_TRUE
          block_min_width['hidden']  = HtmlAttribute::BOOL_TRUE
          block_margin['unset'] = HtmlAttribute::BOOL_FALSE
          block_margin['psvalue'] = 'auto'  
        
        self.updated_html_attribute_values.push(block_width,block_min_width,block_margin )
      elsif self.section.slug=='container'
    
      end
    end
  
  end
  
end