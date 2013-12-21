include SpreeTheme::SectionPieceParamHelper

#table cell, border,padding
section_piece = Spree::SectionPiece.find 'product_properties'
cell = {"editor_id"=>2, "class_name"=>"cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"32,7,8,6"}

create_section_piece_param( section_piece, cell)


th =  { "editor_id"=>3,  "class_name"=>"th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"2,3,4,5"}  
td =  { "editor_id"=>3,  "class_name"=>"td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)

th = { "editor_id"=>4,  "class_name"=>"th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
td = { "editor_id"=>4,  "class_name"=>"td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)
