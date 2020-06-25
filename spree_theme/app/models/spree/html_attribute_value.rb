module Spree
  class HtmlAttributeValue
    attr_accessor :html_attribute, :param_value
    attr_accessor :properties #hash {pvalue0, psvalue0, unit0, psvalue0_desc, unset, computed}

    delegate :default_properties, :to=>:html_attribute
    # create an instance from a string it is param_value.pvalue[html_attribute_id]
    # create an instance from hash {pvalue0, psvalue0, unit0}
    # params: computed, html_attribute_id is in section_piece_param.computed_ha_ids.
    def self.parse_from(param_value, html_attribute, pvalue_properties={}, media_width = 0)

      if pvalue_properties.empty?
        #pvalue_string could be nil,  in this case, get default_pvalue_string?
        pvalue_properties = do_parse(param_value, html_attribute, media_width)
      else
        # build htmlAttributeValue instane from postd params, we need check "unset" param, set to false if it is nil.
        # tidy posted pvalue_properties, only keep valid values.
        html_attribute.repeats.times{|i|
          psvalue = pvalue_properties["psvalue#{i}"]
          if html_attribute.manual_entry?( psvalue )
            if pvalue_properties["pvalue#{i}"].blank?
              #user select manual_entry, but have not entry any value
              pvalue_properties["pvalue#{i}"], pvalue_properties["unit#{i}"] = html_attribute.default_manual_value
            end
          #else
          #  pvalue_properties.except!(["pvalue#{i}","unit#{i}"])
          end
        }
        # if unset is uncheck, 'unset' is nil in posted params.
        if pvalue_properties["unset"].nil?
          pvalue_properties["unset"] = HtmlAttribute::BOOL_FALSE
        end
      end

      # default unset is checked
      if pvalue_properties["unset"].nil?
        pvalue_properties["unset"] = HtmlAttribute::BOOL_TRUE
      end
      if pvalue_properties["hidden"].nil?
        pvalue_properties["hidden"] = HtmlAttribute::BOOL_FALSE
      end
      # is computed value store in param_value.pvalue, true or false,
      if pvalue_properties["computed"].nil?
        pvalue_properties["computed"] = HtmlAttribute::BOOL_FALSE
      end

      return ultra_initialize(param_value, html_attribute, pvalue_properties)
    end

    #every html_attribute_value, should have defalut value, or pvalue is nil after unset
    def self.do_parse(param_value, html_attribute, media_width)
      #use html attribute value in param_value.pvalue
      pvalue_string = param_value.pvalue_for_haid(html_attribute.id)
      pvalue_unset = param_value.html_attribute_extra(html_attribute.id,'unset')
      pvalue_hidden = param_value.html_attribute_extra(html_attribute.id,'hidden')
      pvalue_computed = param_value.html_attribute_extra(html_attribute.id,'computed')

      object_properties = {"unset"=>pvalue_unset, "hidden"=>pvalue_hidden, "computed"=>pvalue_computed}
      #param_value_class = param_value.section_param.section_piece_param.pclass
        if html_attribute.is_special? :text
          object_properties["psvalue0"] = html_attribute.possible_selected_values.first
          object_properties["pvalue0"] =  pvalue_string
        elsif html_attribute.is_special? :bool
          object_properties["psvalue0"] = html_attribute.possible_selected_values.first
          object_properties["pvalue0"] =  pvalue_string
        elsif html_attribute.is_special? :db
          object_properties["psvalue0"] = html_attribute.possible_selected_values.first
          object_properties["pvalue0"] = pvalue_string.to_i
        else # css and pvalue_string
          if pvalue_string.present?
            html_attribute_slug, vals = pvalue_string.split(':')
            # 'width:'.split(':') -> ['width'], in this case vals is nil,
            # it happened while user select a manul entry and have not enter anything. we should show the empty entry.
            repeats = html_attribute.repeats
            val_arr = vals.nil? ? [] : vals.split()
            repeats.times{|i|
              val = val_arr[i]
              if val.nil? # handle short value.  padding:5px; or margin: 5px 5px;
                # 0,1,2,3
                # t,r,b,l       3%2=1, 2%2=0, 1%2=1
                val||= val_arr[i%2]
                val||= val_arr[0]
              end
              if html_attribute.selected_value?(val)
                object_properties["psvalue#{i}"] = val
              else# it is manual entry.
                object_properties["psvalue#{i}"] = html_attribute.manual_selected_value
                if html_attribute.is_special?(:color) #border-color has unit hex|rgb
                  object_properties["pvalue#{i}"] =  val
                  if html_attribute.has_unit?
                    object_properties["unit#{i}"] = (val=~/^#/ ? html_attribute.units.first : html_attribute.units.last)
                  end
                elsif html_attribute.has_unit?
                  object_properties["pvalue#{i}"],object_properties["unit#{i}"] =  (val.to_i == val.to_f ? val.to_i : val.to_f),val[/[a-z%]+$/]
                else
                  object_properties["pvalue#{i}"] = val
                end
              end
            }

          elsif html_attribute.has_default_value?
            object_properties.merge!( html_attribute.default_properties )
          end
        end
  #Rails.logger.debug "param_value:#{param_value.id}, html_attribute=#{html_attribute.slug},pvalue_string=#{pvalue_string.inspect}, pclass=#{param_value_class},properties=#{object_properties.inspect}"
      object_properties
    end

    def self.build_pvalue_from_properties(param_value, html_attribute, pvalue_properties)
      #use overrided value in pvalue_properties
      pvalue_string = nil
      if html_attribute.is_special? :text
        pvalue_string = pvalue_properties["pvalue0"]
      elsif html_attribute.is_special? :bool
        pvalue_string = pvalue_properties["pvalue0"]
      elsif html_attribute.is_special? :db
        pvalue_string = pvalue_properties["pvalue0"]
      elsif html_attribute.is_special? :image
        #background-image is special,
        # for param_value: format is  css_name:file_name; in this way, editor is easy to parse and render
        # for css: format is css_name:url(file_url);
        pvalue_string = html_attribute.css_name+':'+ ( html_attribute.manual_entry?(pvalue_properties["psvalue0"]) ? "#{pvalue_properties["pvalue0"]}" : pvalue_properties["psvalue0"] )
      else
        pvalue_string = html_attribute.css_name+':'+ build_css_property_value(  html_attribute, pvalue_properties, param_value )
      end
      pvalue_string
    end

    def self.build_css_property_value( html_attribute, pvalue_properties, param_value )
      val = ''
      if html_attribute.is_special?(:image)
        if html_attribute.manual_entry?(pvalue_properties["psvalue0"])
          file = TemplateFile.find_by( theme_id: param_value.theme_id, attachment_file_name: pvalue_properties["pvalue0"] )
          if file.present?
            val = "url(#{file.attachment.url})"
          end
        else
          val = pvalue_properties["psvalue0"]
        end
      else
        vals = html_attribute.repeats.times.collect{|i|
          if html_attribute.is_special? :color #no need unit for color
            html_attribute.manual_entry?(pvalue_properties["psvalue#{i}"]) ?
              "#{pvalue_properties["pvalue#{i}"]}" : pvalue_properties["psvalue#{i}"]
          else
            html_attribute.manual_entry?(pvalue_properties["psvalue#{i}"]) ?
              "#{pvalue_properties["pvalue#{i}"]}#{pvalue_properties["unit#{i}"]}" : pvalue_properties["psvalue#{i}"]
          end
        }
        if html_attribute.css_name == 'background-size' && html_attribute.selected_value?( vals[0])
          vals = vals.uniq # ['contain' 'contain'] => ['contain']
        end
        val = vals.join(' ')
      end
      val
    end

    def self.ultra_initialize(param_value, html_attribute, properties)
      hav = HtmlAttributeValue.new
      hav.html_attribute = html_attribute
      hav.param_value = param_value
      hav.properties = properties
      hav
    end


    # param: properties to string  {'pvalue0'=>'90','unit0'=>'px'} -> 'wdith:90px'
    def build_pvalue(default=false)

      return default ? self.class.build_pvalue_from_properties(param_value, html_attribute, html_attribute.default_properties) :
        self.class.build_pvalue_from_properties(param_value, html_attribute, properties)
    end

    def equal_to?(another_instance)
      return ((self.html_attribute.id==another_instance.html_attribute.id) and
      (self.hidden? == another_instance.hidden?) and
      ((self.unset? and another_instance.unset?) or
       ((self.unset? == another_instance.unset?) and (self.build_pvalue ==another_instance.build_pvalue) )))
    end

    # get pvalue, psvalue, unit, unset
    # if the reperts==1  key are pvalue, psvalue, unit,unset
    # if the reperts>1   hav[pvalue{n}],hav[psvalue{n}], hav[unit{n}]   ,n start from 0
    def [](key)

      #return properties[key] if key=~/unset/
      # pvalue and pvalue0 both return pvalue0
      key=~/[\d]$/ ? properties[key] : properties[key+'0']

    end

    # set pvalue, psvalue, unit, unset
    # if the reperts==1  key are pvalue, psvalue, unit,unset
    # if the reperts>1   key are pvalue{n}, psvalue{n}, n start from 0
    # ex. ['pvalue'] = '500px'
    def []=(key,val)
      #unset or bool like this way
      if val.kind_of?(TrueClass) || val.kind_of?(FalseClass)
        val = val ? HtmlAttribute::BOOL_TRUE : HtmlAttribute::BOOL_FALSE
      end
      if key=~/unset/
        properties[key] = val
        #it has default value at least while initialize!
      elsif key=~/hidden/
        properties[key] = val
      elsif key=~/[\d]$/
        properties[key] = val
      else
        self.html_attribute.repeats.times{|i|
          properties[key+i.to_s] = val
        }
      end
      if key=~/pvalue/ # in code we could set 'width=200'
        # correct psvalue and unit
        if self.unset?
          properties['unset'] = HtmlAttribute::BOOL_FALSE
        end
        unless self.html_attribute.manual_entry? self['psvalue']
          self['psvalue'] =  self.html_attribute.manual_selected_value
          if self.html_attribute.has_unit?
            self['unit'] =  self.html_attribute.units.first
          end
        end
      end
    end

    # return pvalue with right type, db:int, bool:bool, text:string
    def pvalue( irepeat = 0)
      casted_value = properties["pvalue#{irepeat}"]
      if html_attribute.computable?
        if unset?
          casted_value = 0
        else
          casted_value = casted_value.to_i
        end
      end
      casted_value
    end

    def unset
      return unset? ? HtmlAttribute::BOOL_TRUE : HtmlAttribute::BOOL_FALSE
    end

    def unset?
      return properties["unset"]!=HtmlAttribute::BOOL_FALSE
    end

    def hidden
      return hidden? ? HtmlAttribute::BOOL_TRUE : HtmlAttribute::BOOL_FALSE
    end

    def hidden?
      return properties["hidden"]==HtmlAttribute::BOOL_TRUE
    end

    def bool_true?
      self.properties['pvalue']==HtmlAttribute::BOOL_TRUE ?  true:false
    end

    def manual_entry?(irepeat=0)
      html_attribute.manual_entry?(properties["psvalue#{irepeat}"])
    end

    def computed
      return properties["computed"]
    end

    def computed?
      return properties["computed"]==HtmlAttribute::BOOL_TRUE
    end

    #request url when pvalue|psvalue|unset changed
    # event_enum :ps_changed| :psv_changed
    def build_url_params(event_enum)

      { :editing_param_value_id=> param_value.id, :editing_html_attribute_id=>html_attribute.id, :param_value_event=>ParamValue::EventEnum[event_enum]}

    end

    begin 'css selector, name, value'
      # from param_value page_layout_id, section_param.section_id, section_param.section_root_id, section_param.class_name get selector and prefix
      def css_selector
        target = attribute_class_name
        prefix = case target
          when /cell/ # s_cell or cell
            ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id} td, .s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id} th"
          when /^s\_/
            target = target[2..-1]
            ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id}"
          when /page|sidr/
            "#page"
          when 'content_layout','first_child','last_child'
            ".c_#{self.param_value.page_layout_id}"
          #when /(label|input|img|button|block)/ # product_atc, product_quantity, block_hover
          #  ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id}"
          #when 'as_h','a_h','a','th','td','li'
          #  ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id}"
          else
            ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id}"
          end

        # it has to apply to inner, for root, outer is body, it include editor panel, some css would affect it.
        selector = case target
          when /content_layout/,'block','block_h',/cell/,'page'
            ""
          when /block_/ #block_hovered
            ".#{target}"
          when /inner/
            "> .inner"
          when 'as_h','a_sel' #selected:hover, selected
            " a.selected"
          when 'a_una' #  unavailable, unclickable
            " a.unavailable"
          when 'a','a_h'
            " a"
          #when 'first_child','last_child'
          #  # it is not right way to center content,
          #  # in html, we may add form to wrap each child, first-child do not work in this case.
          #  # padding,margin is applied to inner, it also affect width of outer div
          #  ":#{target[/[a-z]+/]} "
          when /\_h$/  #button_h
            " #{target.delete('_h')}"
          when 'error' #s_error
            " label.error"
          when 'table','label','input','li','img','button','td','th','h6','dt','dd'
            # product quantity,atc section_piece content just input,add a <span> wrap it.
            # product images content thumb and main images so here should be section_id,
            " #{target}"
          when /pagination/
            " #{target.sub('-',' ')}"
          else  #noclick, selected
            " .#{target}"
          end
#Rails.logger.debug "css selector:#{prefix+selector}, #{attribute_name}:#{attribute_value}"
        prefix+selector
      end

      def attribute_name
        self.html_attribute.css_name
      end

      def attribute_value
        target_properties = unset? ? default_properties : properties
        self.class.build_css_property_value( self.html_attribute, target_properties, self.param_value )
      end

      def attribute_class_name
        self.param_value.section_param.section_piece_param.class_name
      end
    end

    # update param_value with self
    def update()
      #Rails.logger.debug "yes, in HtmlAttributeValue.save"
      self.param_value.update_html_attribute_value(self.html_attribute, self.properties, 'system')
    end

  end
end
