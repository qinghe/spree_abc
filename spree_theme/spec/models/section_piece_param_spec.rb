#page_layout.templates
require 'spec_helper'
describe Spree::SectionPieceParam do

  before( :each ) do
    @section_piece_param = create( :section_piece_param )
  end

  it "create section piece param" do
    editor = @section_piece_param.editor
    section_piece = @section_piece_param.section_piece
    param_category =  @section_piece_param.param_category
    attrs = { "editor"=>editor, "section_piece"=>section_piece, "param_category"=>param_category, "class_name"=>"new_name", "pclass"=>"css", "html_attribute_ids"=>"2,3,4,5"}
    spp = Spree::SectionPieceParam.new( attrs )
    spp.save.should be_truthy
    #sections = spp.section_piece.sections.includes(:section_params)
    #section_params = sections.collect{|section| section.section_params.select{|sp| sp.section_piece_param == spp} }.flatten
    #sections.size.should == section_params.size
  end

  it 'has many section_params' do
    @section_piece_param.section_params
  end

  it 'destroy section_params and param_values together' do
    section_params = @section_piece_param.section_params
    @section_piece_param.destroy
    Spree::SectionParam.where(:section_piece_param_id=> @section_piece_param.id).should be_blank
    for section_param in section_params
      Spree::ParamValue.where(:section_param_id=>section_param.id).should be_blank
    end

  end

  context " new html attribute height" do
    before(:each) do
      @html_attribute_height = create( :html_attribute_height )
    end
    it "insert html_attribute" do
      spp = @section_piece_param
      spp.insert_html_attribute( @html_attribute_height )
      #spp.insert_html_attribute( @html_attribute_height).should raise_error

    end
  end
end
