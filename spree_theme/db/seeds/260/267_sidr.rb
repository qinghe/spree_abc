#param category 501  sidr close
#param category 502  sidr overlay

# section param for sidr_overlay and sidr_close
section_piece = Spree::SectionPiece.where( slug: 'click-effect-sider' ).first

sidr_close =  { "editor_id"=>2,  "class_name"=>"sidr_close", "pclass"=>"css", "param_category_id"=>501,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, sidr_close)

sidr_close =  { "editor_id"=>4,  "class_name"=>"sidr_close", "pclass"=>"css", "param_category_id"=>501,  "html_attribute_ids"=>"24,27,49,53,54"}
create_section_piece_param( section_piece, sidr_close)

sidr_overlay =  { "editor_id"=>3, "class_name"=>"sidr_overlay", "pclass"=>"css", "param_category_id"=>502,  "html_attribute_ids"=>"2,3,4,5,116"}

create_section_piece_param( section_piece, sidr_overlay)
