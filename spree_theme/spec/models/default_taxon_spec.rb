require 'spec_helper'
describe DefaultTaxon do
  let (:taxon) { DefaultTaxon.instance}
  
  it "has right context" do
    taxon.current_context.should == :list
    taxon.request_fullpath = '/0'
    taxon.current_context.should == :list
    taxon.request_fullpath = '/0/1'
    taxon.current_context.should == :detail
    taxon.request_fullpath = '/cart'
    taxon.current_context.should == :cart    
  end
  
  it "has default root" do
    taxon.root.should be_a_kind_of DefaultTaxon
    taxon.root.children.size.should eq 1
    taxon.root.children.should include( taxon )
  end
  
  it "instantiate by context" do
    cart = DefaultTaxon.instance_by_context( DefaultTaxon::ContextEnum.cart )
    cart.should be_a_kind_of DefaultTaxon
    cart.current_context.should eq DefaultTaxon::ContextEnum.cart
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
