require 'spec_helper'
describe Spree::SectionPiece do
  let (:section_piece) { Spree::SectionPiece.first }
  
  
  it "has wrapped contexts" do
    section_piece = Spree::SectionPiece.find('logged-and-unlogged-menu')         
    logged_resource_context, unlogged_resource_context =  section_piece.wrapped_resources
    logged_resource_context.context.should eq DefaultTaxon::ContextEnum.account
    unlogged_resource_context.context.should eq DefaultTaxon::ContextEnum.login
  end
  
  it "generate right css selector" do
    spp = Spree::SectionPieceParam.find_by_class_name 'page'
    pv = spp.section_params.first.param_values.first
    html_attribute_id, html_attribute_value = pv.html_attribute_values_hash.first
    html_attribute_value.css_selector.should eq '#page'
  end  

  it "generate right css selector2" do
    spp = Spree::SectionPieceParam.find_by_class_name 'depth1'
    pv = spp.section_params.first.param_values.first
    css_selector_prefix = ".s_#{pv.page_layout_id}_#{pv.section_param.section_id}"
    html_attribute_id, html_attribute_value = pv.html_attribute_values_hash.first
    html_attribute_value.css_selector.should eq  css_selector_prefix+" .depth1"
  end  
end
