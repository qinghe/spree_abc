module Spree
  class SectionPieceParam < ActiveRecord::Base
    acts_as_list :scope => :section_piece_id
    
    belongs_to :section_piece
    belongs_to :param_category
    belongs_to :editor
    has_many :section_params, :dependent=>:destroy
    serialize :param_conditions, Hash #{html_attribute_id=>[:change]}  
    attr_accessible :editor,:param_category, :section_piece, :class_name, :pclass, :html_attribute_ids
    
    PCLASS_DB="db" # param which contain html_attribute db should named as 'db'
    PCLASS_CSS="css" 
    PCLASS_STYLE="style" 
    
    #section_piece.section_piece_params.create!(:editor_id=>1) would cause ActiveRecord::RecordInvalid: Validation failed: Editor can't be blank
    #validates :editor, :presence=>true
    #validates :param_category, :presence=>true
    validates :editor, :param_category, :section_piece, :presence=>true
    after_create :add_section_params
    
    def html_attributes
      if @html_attributes.nil?
        ha_ids = self.html_attribute_ids.split(',').collect{|i|i.to_i}
        @html_attributes= HtmlAttribute.find_by_ids(ha_ids)
  
      end
      @html_attributes
    end
    
    def param_keys
      self.html_attribute_ids.split(',').collect{|i| [i.to_i, "#{i}unset", "#{i}hidden"]}.flatten
    end
    
    def insert_html_attribute( html_attribute, before_existing_html_attribute = nil )
      existing_html_attributes = html_attributes
      raise "html_attrubte #{html_attribute.title} already exsiting." if existing_html_attributes.include? html_attribute
      if before_existing_html_attribute.present?
        insert_position = existing_html_attributes.index( before_existing_html_attribute )
        raise "can not found exsiting html attribute #{before_existing_html_attribute.title}" if insert_position.nil?
        existing_html_attributes.insert( insert_position, html_attribute)
      else
        existing_html_attributes.push( html_attribute )
      end
     self.update_attributes! :html_attribute_ids=>existing_html_attributes.map(&:id).join(',')    
      
    end
    
    # only for seed or data patch
    def add_param_value_event( html_attribute, event)
      if param_conditions[html_attribute.id]
        unless param_conditions[html_attribute.id].include?( event )
          param_conditions[html_attribute.id]<< event
          save!
        end
      end  
    end
    
    # is it editable for specified data_source
    def editable?(data_source)
      if editable_condition.present?
        case data_source
        when Spree::PageLayout::DataSourceEnum.gpvs
          editable_condition.include?( "data_source:gpvs")
        when Spree::PageLayout::DataSourceEnum.blog
          editable_condition.include?( "data_source:blog")
        else
          false
        end
      else
        true
      end
    end
       
    private
    #add section_param where section.section_piece_id = ? for each section tree.
    def add_section_params
      sections = Section.where(:section_piece_id=>self.section_piece_id)
      for section in sections
        section.section_params.create do|section_param|
          section_param.section_root_id = section.root_id
          section_param.section_piece_param_id = self.id
        end
      end
    end
        
  end

end