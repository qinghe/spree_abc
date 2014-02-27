require 'spec_helper'
describe Spree::SectionPiece do
  let (:section_piece) { Spree::SectionPiece.first }
  
  
  it "has wrapped contexts" do
    section_piece = Spree::SectionPiece.find('logged-and-unlogged-menu')         
    logged_resource_context, unlogged_resource_context =  section_piece.wrapped_resources
    logged_resource_context.context.should eq DefaultTaxon::ContextEnum.account
    unlogged_resource_context.context.should eq DefaultTaxon::ContextEnum.login
  end
  
end
