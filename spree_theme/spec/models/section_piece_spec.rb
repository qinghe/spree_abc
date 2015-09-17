require 'spec_helper'
describe Spree::SectionPiece do
  let( :section_piece_param ) { create(:section_piece_param) }
  let!( :section_piece ) { create(:section_piece, :section_piece_params =>[ section_piece_param ] ) }

  let( :attrs) { {"editor"=>section_piece_param.editor, "class_name"=>"s_a", "pclass"=>"css", "param_category"=>section_piece_param.param_category,  "html_attribute_ids"=>"7,8,6"} }
  let( :create_section_piece_param ){ section_piece.section_piece_params.create!( attrs ) }

  it 'add section piece param' do
    expect{ create_section_piece_param }.to change{ Spree::SectionPieceParam.count}.by(1)
  end

  describe "add section piece param into section_piece of section " do
    before(:each) do
       @section = create(:section, :section_piece => section_piece)
    end

    it "add section param as well" do
      expect{ create_section_piece_param }.to change{ Spree::SectionParam.count}.by(1)
    end

  end

  describe "add section piece param into section_piece of page_layout" do
    before(:each) do
      @section = create(:section, :section_piece => section_piece)
      @page_layout = create(:page_layout, :section => @section)
    end

    it "add section param as well" do
      expect{ create_section_piece_param }.to change{ Spree::ParamValue.count}.by(1)
    end
  end

end
