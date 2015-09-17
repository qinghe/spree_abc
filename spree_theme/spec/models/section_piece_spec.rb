require 'spec_helper'
describe Spree::SectionPiece do
  let(:section_piece) { create(:section_piece) }

  it 'add section piece param' do
    attrs =  { "editor_id"=>2, "class_name"=>"s_a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"7,8,6"}

    section_piece.section_piece_params.create! do|spp|
      spp.param_conditions={}
      spp.assign_attributes( attrs )
    end

  end
end
