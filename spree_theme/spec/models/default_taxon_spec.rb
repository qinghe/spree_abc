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
  
  
  #TODO
  # test add_section_piece, section_param should be added
end
