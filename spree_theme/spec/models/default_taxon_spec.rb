require 'spec_helper'
describe DefaultTaxon do
  let (:taxon) { DefaultTaxon.instance}

  it "should be default root" do
    taxon_root = DefaultTaxonRoot.instance
    taxon_root.should be_a_kind_of DefaultTaxonRoot
    taxon_root.root.should == taxon_root
    taxon_root.children.size.should eq 1
    taxon_root.children.each{|node| node.should be_a_kind_of DefaultTaxon }    
    taxon_root.self_and_descendants.size.should eq 2
    taxon_root.taxonomy.should be_a_kind_of DefaultTaxonomy
  end
  
  it "has right context" do
    taxon.current_context.should == :list
    taxon.request_fullpath = '/0'
    taxon.current_context.should == :list
    taxon.request_fullpath = '/0/1'
    taxon.current_context.should == :detail
    taxon.request_fullpath = '/cart'
    taxon.current_context.should == :cart    
    
    taxon = Spree::Taxon.new
    taxon.request_fullpath.should be_blank
    taxon.current_context.should == :list
  end
  
  
  it "instantiate by context" do
    DefaultTaxon::ContextEnum.each{|context| 
      next if [ DefaultTaxon::ContextEnum.list, DefaultTaxon::ContextEnum.detail, DefaultTaxon::ContextEnum.blog, DefaultTaxon::ContextEnum.post,DefaultTaxon::ContextEnum.thanks, DefaultTaxon::ContextEnum.password].include? context
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
  
  it "support inherited page context" do
    taxon_root = DefaultTaxonRoot.instance
    taxon_root.page_context = 1    
    taxon_root.children.each{ |default_taxon|
      default_taxon.root.should eq taxon_root     
      default_taxon.current_context.should eq DefaultTaxon::ContextEnum.home
    }
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
