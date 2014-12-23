

section_piece = find_section_piece 'container-table'
  
th = {"editor_id"=>2, "class_name"=>"s_th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"32,7,8,6"}
unless Spree::SectionPieceParam.where( th ).any?
  create_section_piece_param( section_piece, th)
end

section_params = Spree::SectionParam.eager_load(:section_piece_param).where(["spree_section_piece_params.class_name=?",'block_h'])

if section_params.any?
  section_params.each{|param|
    param.update_attribute(:is_enabled, false)    
  }
end
