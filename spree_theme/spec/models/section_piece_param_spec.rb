#page_layout.templates
require 'spec_helper'
describe Spree::SectionPieceParam do
  let (:section_piece_param) { Spree::SectionPieceParam.first }
  
  it "create section piece param" do
    original_param_value_count = Spree::ParamValue.count()
    editor = Spree::Editor.first
    section_piece = Spree::SectionPiece.find_by_title('container')
    param_category = Spree::ParamCategory.first
    attrs = { "editor"=>editor, "section_piece"=>section_piece, "param_category"=>param_category, "class_name"=>"new_name", "pclass"=>"css", "html_attribute_ids"=>"2,3,4,5"}
    spp = Spree::SectionPieceParam.new( attrs )
    spp.save.should be_true    
    sections = spp.section_piece.sections.includes(:section_params)
    section_params = sections.collect{|section| section.section_params.select{|sp| sp.section_piece_param == spp} }.flatten    
    sections.size.should == section_params.size

    #each section_root has how much section_piece.
    root_and_count_hash = sections.inject({}){|hash, section| hash[section.root_id]||=0; hash[section.root_id]+=1; hash}
    #how much page_layout using section_root.
    page_layouts = Spree::PageLayout.all(:conditions=>["section_id in (?)",root_and_count_hash.keys],:include=>:themes)
    
    count = page_layouts.inject(0){|sum, page_layout|
      sum+= page_layout.themes.size*root_and_count_hash[page_layout.section_id]
    }        
    new_param_value_count = Spree::ParamValue.count()
Rails.logger.debug "new_param_value_count=#{new_param_value_count},original_param_value_count=#{original_param_value_count}"    
    new_param_value_count.should ==(original_param_value_count+count)
  end
  
  it 'has many section_params' do
    section_piece_param.section_params.should be_kind_of Array
  end
  
  it 'destroy section_params and param_values together' do
    section_params = section_piece_param.section_params
    section_piece_param.destroy    
    Spree::SectionParam.where(:section_piece_param_id=>section_piece_param.id).should be_blank
    for section_param in section_params      
      Spree::ParamValue.where(:section_param_id=>section_param.id).should be_blank
    end
    
  end
   
   
  it "insert html_attribute" do
    padding = Spree::HtmlAttribute.find 32
    margin = Spree::HtmlAttribute.find 31
    spp = Spree::SectionPieceParam.where(:editor_id=>2, :class_name=>'content_layout').first    
    spp.insert_html_attribute( padding)    
    spp.insert_html_attribute( padding).should raise_error
    spp.insert_html_attribute( padding, margin).should raise_error
    
  end   
end