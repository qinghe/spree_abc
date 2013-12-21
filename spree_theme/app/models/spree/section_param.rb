module Spree
  class SectionParam < ActiveRecord::Base  
    has_many :param_values, :dependent=>:destroy
    belongs_to :section_piece_param
    belongs_to :section
    serialize :default_value, Hash
    
    after_create :add_param_values

    def disabled_html_attribute_ids
      if @disabled_html_attribute_ids.nil?
        @disabled_html_attribute_ids = self.disabled_ha_ids.split(',').collect{|i|i.to_i}
      end
      @disabled_html_attribute_ids
    end
    
    
    #filter:  :all, :disabled, :enabled
    def html_attributes(attribute_filter= :enabled)
      if @html_attributes.nil?
        ha_ids = self.section_piece_param.html_attribute_ids.split(',').collect{|i|i.to_i}
        @html_attributes= HtmlAttribute.find_by_ids(ha_ids)
      end
  
      case attribute_filter
      when :enabled
        return_html_attributes = @html_attributes.select{|ha| !disabled_html_attribute_ids.include?(ha.id)}
      when :disabled
        return_html_attributes = @html_attributes.select{|ha| disabled_html_attribute_ids.include?(ha.id)}      
      else
        return_html_attributes = @html_attributes
      end
      
    end
    
    
    begin 'these methods only for development and system improvement'
      def add_default_values( html_attribute_values)
        
      end
      
      # ex. font-weight:bold, font-weight html_attribute id is 27,  add_default_value(27,'font-weight:bold')
      def add_default_value( html_attribute_id, html_attribute_value )
        self.default_value[html_attribute_id] = html_attribute_value
        self.save!
        #get related param_values, if html_attribute_id is nil, set default value
        self.param_values.each{|pv|          
          pv.pvalue[html_attribute_id] = html_attribute_value
          #do not use update_column, or pv.pvalue would raise 'string not matched (IndexError)' during calling next time  
          pv.save!
          #pv.update_column(:pvalue, pv.pvalue.to_yaml)
        }
      end
      
      def remove_default_value(html_attribute_id)
        if self.default_value.key? html_attribute_id
          default_html_attribute_value = self.default_value.delete html_attribute_id
          self.save!        
          #get related param_values, if html_attribute_id is nil, set default value
          self.param_values.each{|pv|            
            if pv.pvalue[html_attribute_id] == default_html_attribute_value
              pv.pvalue.delete html_attribute_id
              pv.update_column(:pvalue, pv.pvalue.to_yaml)
            end
          }
        end
      end
    end
    private
    #add param_value where page_layout.section_id = ? for each layout tree.
    def add_param_values    
      page_layouts = PageLayout.includes(:themes).where("section_id"=>self.section.root_id)
      for page_layout in page_layouts
        for theme in page_layout.themes
            page_layout.param_values.create do|param_value|
              param_value.theme_id = theme.id
              param_value.page_layout_root_id = page_layout.root_id              
              param_value.section_param_id = self.id
            end
        end
      end
    end
    
    
  end
  
end