require 'spec_helper'
describe Spree::Section do
  let (:section) { Spree::Section.first }
  
  it "has right section params" do
    Spree::Section.roots.each{|hmenu|
      section_piece_params = hmenu.self_and_descendants.collect{|section| section.section_piece.section_piece_params}.flatten
      section_params = hmenu.self_and_descendants.collect{|section| section.section_params}.flatten    
      section_params.size.should ==section_piece_params.size
    }
    
    section_params = Spree::SectionParam.includes(:section_piece_param).all    
    for sp in section_params
      (sp.default_value.keys-sp.section_piece_param.param_keys).should be_blank
      (sp.html_attributes(:disabled) - sp.section_piece_param.html_attributes).should be_blank
    end
    
  end
  
  it "destroy a section" do
    section.section_params.size.should be > 0 
    section.destroy
  end

  it "a section has page_layouts" do
    section.page_layouts.build.should be_present
  end
  
  it "build cart section html" do
    cart = Spree::Section.find_by_title('cart')
    html = cart.build_html
    html.should =~/yield/
  end
  
  # test add_section_piece, section_param should be added
  it "build section with default param value" do
    bool_false = Spree::HtmlAttribute::BOOL_FALSE
    bool_true =  Spree::HtmlAttribute::BOOL_TRUE
    section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

    #container-title
    Spree::Section.where(:title=>'container with title').each(&:destroy)
    container = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"container with title"},
      {'block'=>{15=>"height:100px",'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
    container.add_section_piece(section_piece_hash['container-title'].id)
    section_params = Spree::SectionParam.where(:section_root_id=>container.id).includes(:section_piece_param)
    
    for sp in section_params
      (sp.default_value.keys-sp.section_piece_param.param_keys).should be_blank
      
      (sp.html_attributes(:disabled) - sp.section_piece_param.html_attributes).should be_blank
    end
    
  end
end
