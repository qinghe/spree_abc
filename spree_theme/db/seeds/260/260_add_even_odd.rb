# section param for dialog_overlay and dialog_close
section_piece = Spree::SectionPiece.where( slug: 'menuitem' ).first

cycle_even =  { "editor_id"=>3,  "class_name"=>"even", "pclass"=>"css", "param_category_id"=>195,  "html_attribute_ids"=>"2,3,4,5,116"}
create_section_piece_param( section_piece, cycle_even)

cycle_odd =  { "editor_id"=>3,  "class_name"=>"odd", "pclass"=>"css", "param_category_id"=>196,  "html_attribute_ids"=>"2,3,4,5,116"}
create_section_piece_param( section_piece, cycle_odd)
