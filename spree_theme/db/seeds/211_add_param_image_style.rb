
include SpreeTheme::SectionPieceParamHelper

#form button, button:hover
section_piece = Spree::SectionPiece.find 'product-image'

button = { "editor_id"=>2,  "class_name"=>"image_style", "pclass"=>"text", "param_category_id"=>28,  "html_attribute_ids"=>"84"}  
create_section_piece_param( section_piece, button)