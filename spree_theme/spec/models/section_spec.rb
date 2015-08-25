require 'spec_helper'
describe Spree::Section do
  let (:section) { create(:section) }

  #it "has right section params" do
  #  Spree::Section.roots.each{|hmenu|
  #    section_piece_params = hmenu.self_and_descendants.collect{|section| section.section_piece.section_piece_params}.flatten
  #    section_params = hmenu.self_and_descendants.collect{|section| section.section_params}.flatten
  #    section_params.size.should ==section_piece_params.size
  #  }
  #  section_params = Spree::SectionParam.includes(:section_piece_param).all
  #  for sp in section_params
  #    (sp.default_value.keys-sp.section_piece_param.param_keys).should be_blank
  #    (sp.html_attributes(:disabled) - sp.section_piece_param.html_attributes).should be_blank
  #  end
  #end

  it "destroy a section" do
    section.section_params.create!
    section_id = section.id
    section.destroy
    Spree::SectionParam.exists?(section_id: section_id).should be_falsey
  end

  it "has many page_layouts" do
    section.respond_to?( :page_layouts).should be_truthy

  end

  context "build html,css,js" do
    let (:section) { create(:section_with_children).reload }

    it "build  html" do
      html = section.build_html
      html.should eq "<div> this is a section piece </div>"
    end
  end

  context "create section" do
    let( :bool_false) { Spree::HtmlAttribute::BOOL_FALSE }
    let( :bool_true) { Spree::HtmlAttribute::BOOL_TRUE }
    before(:each){
      @section_piece_container = create(:section_piece_container)
    }
    # test add_section_piece, section_param should be added
    it "build section with default param value" do

      container = Spree::Section.create_section( @section_piece_container, {:title=>"container with title"},
        {'block'=>{15=>"height:100px",'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
      container.add_section_piece(@section_piece_container)

      #section_params = Spree::SectionParam.where(:section_root_id=>container.id).includes(:section_piece_param)
      #for sp in section_params
      #  (sp.default_value.keys-sp.section_piece_param.param_keys).should be_blank
      #  (sp.html_attributes(:disabled) - sp.section_piece_param.html_attributes).should be_blank
      #end
    end
  end
end
