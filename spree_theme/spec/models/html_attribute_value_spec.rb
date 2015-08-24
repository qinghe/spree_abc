require 'spec_helper'
describe Spree::HtmlAttributeValue do
  before(:each) do
    @html_attribute_width = create(:html_attribute_width)
    @param_value = create(:param_value )
  end

  it "should parse param_value" do
    hav = Spree::HtmlAttributeValue.parse_from( @param_value, @html_attribute_width)
  end

  #it "has wrapped contexts" do
  #  section_piece = Spree::SectionPiece.friendly.find('logged-and-unlogged-menu')
  #  logged_resource_context, unlogged_resource_context =  section_piece.wrapped_resources
  #  logged_resource_context.context.should eq DefaultTaxon::ContextEnum.account
  #  unlogged_resource_context.context.should eq DefaultTaxon::ContextEnum.login
  #end

  it "generate right css selector" do

    #generate 'page' => '#page'
    #spp = Spree::SectionPieceParam.find_by_class_name 'page'
    #pv = spp.section_params.first.param_values.first
    #html_attribute_id, html_attribute_value = pv.html_attribute_values_hash.first
    #html_attribute_value.css_selector.should eq '#page'
  end
  context 'test css selector' do
    let(:html_attribute_value){
      hav = Spree::HtmlAttributeValue.new
      hav.param_value =@param_value
      hav.html_attribute = @html_attribute_width
      hav
    }
    before(:each) do
      @html_attribute_value = html_attribute_value
    end

    it "generate right css selector2" do
      allow( @html_attribute_value ).to receive( :attribute_class_name ).and_return('block')
      #block
      pv = @param_value

      css_selector_prefix = ".s_#{pv.page_layout_id}_#{pv.section_param.section_root_id}"

      @html_attribute_value.css_selector.should eq  css_selector_prefix
    end
  end
end
