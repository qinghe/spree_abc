
include SpreeTheme::SectionPieceParamHelper

#table cell, border,padding


  section_piece = Spree::SectionPiece.find 'product_quantity'
  position =  { "editor_id"=>2,  "class_name"=>"input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"21,15,31,32,7,8,6"}  
  background =  { "editor_id"=>3,  "class_name"=>"input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"2,3,4,5"}  
  font =  { "editor_id"=>4,  "class_name"=>"input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
  create_section_piece_param( section_piece, position)
  create_section_piece_param( section_piece, background)
  create_section_piece_param( section_piece, font)


  section_piece = Spree::SectionPiece.find 'product_atc'
  position =  { "editor_id"=>2,  "class_name"=>"button", "pclass"=>"css", "param_category_id"=>45,  "html_attribute_ids"=>"21,15,31,32,7,8,6"}  
  background =  { "editor_id"=>3,  "class_name"=>"button", "pclass"=>"css", "param_category_id"=>45,  "html_attribute_ids"=>"2,3,4,5"}  
  font =  { "editor_id"=>4,  "class_name"=>"button", "pclass"=>"css", "param_category_id"=>45,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
  create_section_piece_param( section_piece, position)
  create_section_piece_param( section_piece, background)
  create_section_piece_param( section_piece, font)

