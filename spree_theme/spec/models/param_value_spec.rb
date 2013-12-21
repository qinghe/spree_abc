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
  
  
end