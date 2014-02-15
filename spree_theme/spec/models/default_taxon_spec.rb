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
    DefaultTaxon::ContextEnum.each{|context| 
      next if [ DefaultTaxon::ContextEnum.list, DefaultTaxon::ContextEnum.detail, DefaultTaxon::ContextEnum.thanks].include? context
      taxon = DefaultTaxon.instance_by_context( context )
      taxon.should be_a_kind_of DefaultTaxon
      if context == DefaultTaxon::ContextEnum.either
        taxon.current_context.should eq DefaultTaxon::ContextEnum.home
      else
        taxon.current_context.should eq context
      end
    }
  end
  
  it "should has path/context" do
    taxon.path.should be_present
    taxon.current_context.should be_present
  end

  it "should has self_and_descendant" do
    taxon.self_and_descendants.should be_present
    taxon.self_and_descendants.size.should eq 2
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
