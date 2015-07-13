include SpreeTheme::SectionPieceParamHelper

section_piece = Spree::SectionPiece.find "product-name"
a =  { "editor_id"=>3,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"2,3,4,5"}  
a_h =  { "editor_id"=>3,  "class_name"=>"a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)

a = { "editor_id"=>4,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
a_h = { "editor_id"=>4,  "class_name"=>"a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)
