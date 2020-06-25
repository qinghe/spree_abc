section_piece = find_section_piece 'slider-scrolling'
unless section_piece.section_piece_params.exists?( :class_name=>'slides' )
  slides =  { "editor_id"=>2,  "class_name"=>"slides", "pclass"=>"css", "param_category_id"=>20,  "html_attribute_ids"=>"78,79"}
  create_section_piece_param( section_piece, slides)
end


section_piece = find_section_piece 'slider-core'
unless section_piece.section_piece_params.exists?( :class_name=>'slides' )
  slides =  { "editor_id"=>2,  "class_name"=>"slides", "pclass"=>"css", "param_category_id"=>20,  "html_attribute_ids"=>"78,79"}
  create_section_piece_param( section_piece, slides)
end
