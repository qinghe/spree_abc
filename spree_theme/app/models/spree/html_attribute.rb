module Spree
  # assume html_attribute could has only one manual selected value, position always is last
  class HtmlAttribute < ActiveRecord::Base
    extend FriendlyId
    BOOL_TRUE='1'
    BOOL_FALSE='0'
    
    cattr_accessor :psv_for_manual_entry_enum, :unit_collection, :special_enum
    # slug db,bool,text,src pvalue are special
    #possible selected value for manual entry
    self.psv_for_manual_entry_enum =  {:href=>'0u', :bool=>'0b', :text=>'0t', :size=>'l1', :color=>'0c', :src=>'0i',:db=>'0d', :image=>'0i'}
    self.unit_collection = {:l=>['px','em']}
    
    friendly_id :title, :use => :slugged
  
    
    @@html_attribute_hash = nil
    def self.all_to_hash
      if @@html_attribute_hash.nil?
        html_attributes = HtmlAttribute.all
        @@html_attribute_hash = html_attributes.inject({}){|h, ha| h[ha.id] = ha;h[ha.slug] = ha; h}
      end
      @@html_attribute_hash
    end
    
    def self.find_by_ids(html_attribute_ids)
      (html_attribute_ids.kind_of? ::Array) ? all_to_hash.values_at(*html_attribute_ids) : all_to_hash.fetch(html_attribute_ids)
    end
    
    def self.[](key)
      all_hash = self.all_to_hash
      val = psv_for_manual_entry_enum[key]
      all_hash[val.to_s] 
    end
    
    #keys are db, bool, text, src, color
    #key should only be symbol
    def is_special?(key)
      selected_value?(self.class.psv_for_manual_entry_enum[key.to_sym])       
    end
    
    def repeats
      (self.pvspecial.size>0 and self.pvspecial.size<=4) ? self.pvspecial.size : 1
    end
    
    # each i of repeats have its own possible selected values.
    def possible_selected_values(irepeat = 0)
      
      if @possible_selected_values.nil?
        psv = self.pvalues.split(',')
          psv_for_repeats= []
          self.repeats.times{|i|
            if self.pvalues.include?('|') 
            # 'background-position', 'left|top,center|center,right|bottom,l1|l1', 'Left|top,Center|center,Right|bottom,L1|l1'
              psv_for_repeats << psv.collect{|v| v.split('|')[i]}   
                
            else
              psv_for_repeats<<psv      
            end
          }      
        @possible_selected_values = psv_for_repeats
      end
      @possible_selected_values[irepeat]
    end
    
    def possible_selected_values_descriptions(irepeat = 0)
      if @possible_selected_values_descriptions.nil?
        psv = self.pvalues_desc.split(',')
          psv_for_repeats= []
          self.repeats.times{|i|
            if self.pvalues_desc.include?('|') 
            # 'background-position', 'left|top,center|center,right|bottom,l1|l1', 'Left|top,Center|center,Right|bottom,L1|l1'
              psv_for_repeats << psv.collect{|v| v.split('|')[i]}                 
            else
              psv_for_repeats<<psv      
            end
          }      
        @possible_selected_values_descriptions = psv_for_repeats
      end
      @possible_selected_values_descriptions[irepeat]
    end
    
    def selected_value?(selected_value)
      is_selected = false
      self.repeats.times{|i|
        psv = possible_selected_values(i)
        if psv.include?(selected_value)
          is_selected = true
          break
        end
      }
      is_selected
    end
    # Usage: check the :selected_value a manual entry
    def manual_entry?(selected_value)
      #possible_selected_values.include?(selected_value)
      psv_for_manual_entry_enum.values.include?(selected_value)
    end
    
    # assume html_attribute could has only one manual selected value, position always is last
    def manual_selected_value
      possible_selected_values.last if psv_for_manual_entry_enum.values.include?(possible_selected_values.last)
    end 
    
    def has_unit?
      self.punits.present?
    end
    
    #
    def computable?
      is_special?(:bool) or ['width','height','border-width','margin','padding'].include? self.slug 
    end
    
    def units
      if @units.blank?
        if has_unit?
          @units= []
          punits.split(',').each{|unit|
            if self.class.unit_collection.key?(unit.to_sym)
              @units.concat self.class.unit_collection.fetch(unit.to_sym) 
            else
              @units.push unit
            end 
          }
        end
      end 
      @units
    end
    
    def has_default_value?    
      self.default_value>=0
    end
    
    def default_possible_selected_value(repeat=0)
      if has_default_value?
        possible_selected_values[self.default_value]
      end
    end
    
    #return default manual value and unit
    def default_manual_value(repeat=0)      
      case manual_selected_value
        when psv_for_manual_entry_enum[:color]
          ["#000000",'']
        when psv_for_manual_entry_enum[:size]
          [0,'px']
        when psv_for_manual_entry_enum[:bool]
          [0,'']
        else
          ['','']
      end
    end
    
    def default_properties
      if @default_properties.nil?
        @default_properties = {}
        if has_default_value?
          self.repeats.times{|i|
            @default_properties["psvalue#{i}"] = self.default_possible_selected_value(i)
            if manual_entry?(@default_properties["psvalue#{i}"])
              @default_properties["pvalue#{i}"],@default_properties["unit#{i}"] = default_manual_value(i)
            end
          }
        end
      end
      @default_properties
    end
  end
end