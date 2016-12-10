require 'spec_helper'
describe Spree::SectionParam do
  let (:param_value) { create( :param_value )}
  before(:each) do
    @section_param = param_value.section_param
  end

  it "has right association" do
    @section_param.respond_to?(:param_values).should be_truthy
  end

  it "should add and remove defalut value" do
    section_param = @section_param
    html_attribute_id = '20120930' #new id
    default_value = 'width:0px'
    section_param.add_default_value(html_attribute_id, default_value)
    section_param.reload
    for pv in section_param.param_values
      pv.pvalue[html_attribute_id].should eq default_value
    end
    section_param.remove_default_value(html_attribute_id)
    section_param.reload
    for pv in section_param.param_values
      pv.pvalue[html_attribute_id].should be_nil
    end

  end

  #TODO
  # test add_section_piece, section_param should be added
end
