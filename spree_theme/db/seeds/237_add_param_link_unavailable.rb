include SpreeTheme::SectionPieceParamHelper


section_piece = Spree::SectionPiece.find('container-link')
s_a_sel =  { "editor_id"=>3, "class_name"=>"s_a_una", "pclass"=>"css", "param_category_id"=>15,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, s_a_sel)

s_a_sel =   { "editor_id"=>4,  "class_name"=>"s_a_una", "pclass"=>"css", "param_category_id"=>15,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, s_a_sel)
