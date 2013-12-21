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
    validates :section_piece, :presence=>true
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