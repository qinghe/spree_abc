require 'spec_helper'
describe Spree::ParamValue do
  it "partial_html" do
    Spree::ParamValue.first.partial_html    
  end
  
  it "find within_section&within_editor" do
    param_value = Spree::ParamValue.first
    editor = Spree::Editor.first
    param_values = Spree::ParamValue.within_section( param_value ).within_editor( editor )
    
    for pv in param_values
      pv.theme_id.should eq( param_value.theme_id)      
      pv.page_layout_id.should eq( param_value.page_layout_id)
      pv.section_param.section_piece_param.editor_id.should eq(editor.id)
    end
    
  end
  
  
  it "should trigger pv_change" do
    
    
    
    #section_piece_param_height = Spree::SectionPieceParam.find(:first, :conditions=>["section_piece_id=? and editor_id=? and class_name=?",2, 2, 'block'])
    #section_piece_param_margin = Spree::SectionPieceParam.find(:first, :conditions=>["section_piece_id=? and editor_id=? and class_name=?",2, 2, 'block'])
    
    container = Spree::Section.find('container').page_layouts.first
    
    #section_param_height = container.section_params.find(:first, :conditions=>["section_piece_param_id=?", section_piece_param_height.id])
    
    #param_value = section_param_height.param_values.first
    param_value = container.partial_html.height.param_value
Rails.logger.debug  "param_value_height=#{param_value.inspect}"
    param_value.should be_present
    
    html_attribute_value_params = {"psvalue0"=>"l1", "pvalue0"=>"800", "unit0"=>"px"}
    html_attribute_height = Spree::HtmlAttribute.find('height')
    is_updated, new_html_attribute_value, original_html_attribute_value = param_value.update_html_attribute_value(html_attribute_height, html_attribute_value_params, Spree::ParamValue::EventEnum[:pv_changed] )
    is_updated.should be_true
Rails.logger.debug  "original_html_attribute_value=#{original_html_attribute_value.inspect}"
Rails.logger.debug  "new_html_attribute_value=#{new_html_attribute_value.inspect}"
    param_value.updated_html_attribute_values.should be_present
    
  end
  
  
end