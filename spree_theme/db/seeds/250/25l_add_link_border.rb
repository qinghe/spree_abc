section_piece = Spree::SectionPiece.where( slug: 'container-link' ).first

a =  { "editor_id"=>2, "class_name"=>"s_a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"7,8,6"}
a_h =  { "editor_id"=>2, "class_name"=>"s_a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"7,8,6"}
s_a_sel =  { "editor_id"=>2, "class_name"=>"s_a_sel", "pclass"=>"css", "param_category_id"=>13,  "html_attribute_ids"=>"7,8,6"}
s_a_una =  { "editor_id"=>2, "class_name"=>"s_a_una", "pclass"=>"css", "param_category_id"=>15,  "html_attribute_ids"=>"7,8,6"}

create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)
create_section_piece_param( section_piece, s_a_sel)
create_section_piece_param( section_piece, s_a_una)
