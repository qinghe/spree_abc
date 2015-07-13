require 'spec_helper'
describe Spree::HtmlAttributeValue do
  let (:html_attribute_value) { Spree::ParamValue.first.html_attribute_values_hash.values.first }
    
  it "generate correct css_selector" do
    param_value = SectionPieceParam.find_by_class_name('s_table').section_params.first.param_values.first    
    param_value.html_attribute_values_hash.values.first.css_selector.should eq ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_root_id} table"

  end
  
end
