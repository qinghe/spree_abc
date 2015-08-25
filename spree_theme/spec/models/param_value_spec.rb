require 'spec_helper'
describe Spree::ParamValue do
  let (:param_value) { create(:param_value) }

  it "should have partial_html" do
  #  Spree::ParamValue.first.partial_html
  end

  it "find within_section " do
    param_values = Spree::ParamValue.within_section( param_value )
    for pv in param_values
      pv.theme_id.should eq( param_value.theme_id)
      pv.page_layout_id.should eq( param_value.page_layout_id)
    end
  end

  context 'trigger param value event' do

  #  it "should trigger pv_change" do
  #    html_attribute_height = Spree::HtmlAttribute.find(21)
  #    container = section.page_layouts.first
  #    param_value = container.partial_html.html_attribute_values('block_width').param_value
  #    param_value.should be_present
  #    html_attribute_value_params = {"psvalue0"=>"l1", "pvalue0"=>"800", "unit0"=>"px"}
  #
  #    is_updated, new_html_attribute_value, original_html_attribute_value = param_value.update_html_attribute_value(html_attribute_height, html_attribute_value_params, Spree::ParamValue::EventEnum[:pv_changed] )
  #    is_updated.should be_truthy
  #    param_value.updated_html_attribute_values.should be_present
  #  end

  #  it "height should trigger pv_change" do
  #    html_attribute_height = Spree::HtmlAttribute.find(15)
  #    html_attribute_margin = Spree::HtmlAttribute.find(31)
  #    container = section.page_layouts.first
  #    # set margin
  #    param_value_margin = container.partial_html.html_attribute_values('inner_margin').param_value
  #    html_attribute_value_params = {"psvalue0"=>"l1", "pvalue0"=>"10", "unit0"=>"px", "psvalue1"=>"l1", "pvalue1"=>"0", "unit1"=>"px", "psvalue2"=>"l1", "pvalue2"=>"0", "unit2"=>"px", "psvalue3"=>"l1", "pvalue3"=>"0", "unit3"=>"px"}
  #    is_updated, new_html_attribute_value, original_html_attribute_value = param_value_margin.update_html_attribute_value(html_attribute_margin, html_attribute_value_params, Spree::ParamValue::EventEnum[:pv_changed] )
  #    is_updated.should be_truthy
  #    new_html_attribute_value.pvalue.should eq 10
  #    #set height, inner height should be set.
  #    html_attribute_value_params = {"psvalue0"=>"l1", "pvalue0"=>"800", "unit0"=>"px"}
  #    param_value = container.partial_html.html_attribute_values('block_height').param_value
  #    is_updated, new_html_attribute_value, original_html_attribute_value = param_value.update_html_attribute_value(html_attribute_height, html_attribute_value_params, Spree::ParamValue::EventEnum[:pv_changed] )
  #    is_updated.should be_truthy
  #    param_value.updated_html_attribute_values.should be_present
  #    inner_height = param_value_margin.reload.html_attribute_value( html_attribute_height)
  #    inner_height.pvalue.should eq 790
  #    #unset height, inner height should be 0
  #    html_attribute_value_params = {"psvalue0"=>"l1", "pvalue0"=>"800", "unit0"=>"px", "unset"=>"1"}
  #    is_updated, new_html_attribute_value, original_html_attribute_value = param_value.update_html_attribute_value(html_attribute_height, html_attribute_value_params, Spree::ParamValue::EventEnum[:pv_changed] )
  #    is_updated.should be_truthy
  #    inner_height = param_value_margin.reload.html_attribute_value( html_attribute_height)
  #    inner_height.pvalue.should eq 0
  #  end

  end
end
