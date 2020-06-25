section_piece = Spree::SectionPiece.where( slug: 'bootstrap-dialog-titlebar' ).first

dialog_close =  { "editor_id"=>2,  "class_name"=>"dialog_close", "pclass"=>"css", "param_category_id"=>501,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, dialog_close)

dialog_close =  { "editor_id"=>4,  "class_name"=>"dialog_close", "pclass"=>"css", "param_category_id"=>501,  "html_attribute_ids"=>"24,27,49,53,54"}
create_section_piece_param( section_piece, dialog_close)
