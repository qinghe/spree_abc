# section param for dialog_overlay and dialog_close
section_piece = Spree::SectionPiece.where( slug: 'dialog-title' ).first

dialog_close =  { "editor_id"=>2,  "class_name"=>"dialog_close", "pclass"=>"css", "param_category_id"=>501,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, dialog_close)

dialog_close =  { "editor_id"=>4,  "class_name"=>"dialog_close", "pclass"=>"css", "param_category_id"=>501,  "html_attribute_ids"=>"24,27,49,53,54"}
create_section_piece_param( section_piece, dialog_close)

section_piece = Spree::SectionPiece.where( slug: 'container-dialog' ).first

dialog_overlay =  { "editor_id"=>3, "class_name"=>"dialog_overlay", "pclass"=>"css", "param_category_id"=>502,  "html_attribute_ids"=>"2,3,4,5,116"}

create_section_piece_param( section_piece, dialog_overlay)
