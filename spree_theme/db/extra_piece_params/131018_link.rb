=begin
 
include SpreeTheme::SectionPieceParamHelper

#table title cell, border,padding
section_piece = Spree::SectionPiece.find 'root'


a =  { "editor_id"=>2,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, a)

a =  { "editor_id"=>3, "class_name"=>"a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"2,3,4,5"}
a_h =  { "editor_id"=>3, "class_name"=>"a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"2,3,4,5"}  

create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)

a =   { "editor_id"=>4,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"24,27,49,53,54"}  
a_h =  { "editor_id"=>4,  "class_name"=>"a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)
=end