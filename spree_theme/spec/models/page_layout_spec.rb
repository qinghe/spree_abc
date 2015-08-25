require 'spec_helper'
describe Spree::PageLayout do
  #let (:page_layout) { create(:page_layout) }
  before(:each){
    SpreeTheme.site_class.current = create(:fake_site)
    @page_layout_tree = create(:page_layout_tree)
  }

  #it "build html css js" do
  #  html, css = page_layout.build_content
  #  html.present?.should be_truthy
  #  css.present?.should be_truthy
  #end

  #it "has partial html" do
  #  page_layout.partial_html.should be_kind_of Spree::HtmlPage::PartialHtml
  #end

  #it "create new page_layout tree" do
  #  objects = Spree::Section.roots
  #  section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
    # center area
  #  center_area = Spree::PageLayout.create_layout(section_hash['center_area'], "center_area")
  #  center_area.add_section(section_hash['center_part'],:title=>"center_part")
  #  center_area.add_section(section_hash['left_part'],:title=>"left_part")
  #  center_area.add_section(section_hash['right_part'],:title=>"right_part")

  #  center_area.children.count.should eq(3)
  #  center_area.param_values.count.should eq(0)
  #end

  #it "could replace section" do
  #  original_page_layout = page_layout.dup
  #  root2 = Spree::Section.find('root2')
  #  page_layout.replace_with(root2)
  #  original_page_layout.param_values.empty?.should be_truthy
  #  page_layout.section.should eq root2
  #  page_layout.param_values.present?.should be_truthy
  #end

  #it "has many sections" do
  #  page_layout.respond_to?(:sections).should be_truthy
  #end

  #it "should update datasource" do
    #data_source_gpvs = Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.list].first
    #product_list = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.list)
    #product_list.update_data_source( Spree::PageLayout::DataSourceEmpty)
    #product_list.data_source.should be_blank
    #product_list.update_data_source( data_source_gpvs )
    #product_list.current_data_source.should eq data_source_gpvs
  #end

  #it "should get available data sources" do
  #end

  it "should copy page_layout to new" do

    page_layout_tree = @page_layout_tree.reload
    original_nodes = page_layout_tree.self_and_descendants
    new_node = page_layout_tree.copy_to_new
    new_nodes =  new_node.self_and_descendants

    new_nodes.each_with_index{|node,i|
      node.title.should eq original_nodes[i].title
    }
    expect(original_nodes.size).to eq new_nodes.size
  end
end
