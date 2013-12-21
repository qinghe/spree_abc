require 'spec_helper'
describe Spree::SectionParam do
  let (:section_param) { Spree::SectionParam.first }
    
  it "has right association" do
    section_param.param_values.should be_a_kind_of Array
  end
  
  it "should add and remove defalut value" do
    html_attribute = section_param.section_piece_param.html_attributes.first
    default_value = 'width:0px'
    section_param.add_default_value(html_attribute.id, default_value)
    section_param.reload
    for pv in section_param.param_values
      pv.pvalue[html_attribute.id].should eq default_value
    end
    section_param.remove_default_value(html_attribute.id)
    section_param.reload
    for pv in section_param.param_values
      pv.pvalue[html_attribute.id].should be_nil
    end
    
  end
    
  #TODO
  # test add_section_piece, section_param should be added
end
