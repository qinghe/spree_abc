require 'spec_helper'
describe Spree::PageLayout do
  let (:page_layout) { Spree::PageLayout.first }
  
  it "build html css js" do
    html, css = page_layout.build_content    
    html.present?.should be_true
    css.present?.should be_true
  end

  it "has page script" do
    html, css, js = page_layout.build_content
    html.should match(/proc_page=/)
  end
  
  it "has partial html" do
    page_layout.partial_html.should be_kind_of Spree::HtmlPage::PartialHtml
  end
  
  it "create new page_layout tree" do
  #  objects = Spree::Section.roots
  #  section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
    # center area
  #  center_area = Spree::PageLayout.create_layout(section_hash['center_area'], "center_area")
  #  center_area.add_section(section_hash['center_part'],:title=>"center_part")
  #  center_area.add_section(section_hash['left_part'],:title=>"left_part")
  #  center_area.add_section(section_hash['right_part'],:title=>"right_part")

  #  center_area.children.count.should eq(3)          
  #  center_area.param_values.count.should eq(0)
    
  end
  
  it "valid section context" do
    
    product_detail = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.detail)
    product_detail.context_detail?.should be_true
    product_list = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.list)
    product_list.context_list?.should be_true
  end

  it "could update context" do
    list_section = Spree::PageLayout.find_by_section_context('list')
    detail_section = Spree::PageLayout.find_by_section_context('detail')
    #contexts = [Spree::PageLayout::ContextEnum.account, Spree::PageLayout::ContextEnum.thanks,Spree::PageLayout::ContextEnum.cart, Spree::PageLayout::ContextEnum.checkout]
    contexts = [Spree::PageLayout::ContextEnum.list, Spree::PageLayout::ContextEnum.detail]
    page_layout.update_section_context contexts
    
    for node in page_layout.self_and_descendants
      if node.is_or_is_descendant_of? list_section
        node.current_contexts.should eq(list_section.current_contexts)
      elsif   node.is_or_is_descendant_of? detail_section
        node.current_contexts.should eq(detail_section.current_contexts)
      else
        node.current_contexts.should eq(contexts)  
      end
    end
  end

  it "could verify contexts" do
    Spree::PageLayout.verify_contexts( Spree::PageLayout::ContextEnum.cart, [:cart, :checkout, :thankyou ] ).should be_true
    
    Spree::PageLayout.verify_contexts( [Spree::PageLayout::ContextEnum.cart], [:cart, :checkout, :thankyou ] ).should be_true

    Spree::PageLayout.verify_contexts( Spree::PageLayout::ContextEnum.either, [:cart, :checkout, :thankyou ] ).should be_false
  end
  
  it "could replace section" do
    original_page_layout = page_layout.dup 
    root2 = Spree::Section.find('root2')
    page_layout.replace_with(root2)
    original_page_layout.param_values.empty?.should be_true
    page_layout.section.should eq root2
    page_layout.param_values.present?.should be_true
     
  end
  
  it "has many sections" do
    sections = page_layout.sections
    sections.should be_present
    
    for section in sections
      section.root_id.should == page_layout.section_id
    end
  end
  
  it "should update datasource" do
    data_source_gpvs = Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.list].first
    product_list = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.list)
    product_list.update_data_source( Spree::PageLayout::DataSourceEmpty)
    product_list.data_source.should be_blank
    product_list.update_data_source( data_source_gpvs )
    product_list.current_data_source.should eq data_source_gpvs
  end
  
  it "should get available data sources" do
    
  end
  
  it "should copy page_layout to new" do
    nodes = Spree::PageLayout.root.self_and_descendants
    new_nodes = Spree::PageLayout.copy_to_new(nodes)
    new_nodes.size.should eq nodes.size
    (new_nodes&nodes).should be_blank
    new_nodes.each_with_index{|new_node, index|
      new_node.title.should eq nodes[index].title
    }
  end
end