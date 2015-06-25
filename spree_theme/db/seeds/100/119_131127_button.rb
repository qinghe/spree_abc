

#form button, button:hover
section_piece = find_section_piece 'container-form'

button = { "editor_id"=>2,  "class_name"=>"s_button", "pclass"=>"css", "param_category_id"=>45,  "html_attribute_ids"=>"21,15,31,32,7,8,6"}  
create_section_piece_param( section_piece, button)
button = { "editor_id"=>3,  "class_name"=>"s_button", "pclass"=>"css", "param_category_id"=>45,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, button)
button = { "editor_id"=>4,  "class_name"=>"s_button", "pclass"=>"css", "param_category_id"=>45,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, button)


button = { "editor_id"=>2,  "class_name"=>"s_button_h", "pclass"=>"css", "param_category_id"=>46,  "html_attribute_ids"=>"7,8,6"}  
create_section_piece_param( section_piece, button)
button = { "editor_id"=>3,  "class_name"=>"s_button_h", "pclass"=>"css", "param_category_id"=>46,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, button)
button = { "editor_id"=>4,  "class_name"=>"s_button_h", "pclass"=>"css", "param_category_id"=>46,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, button)

Spree::SectionPieceParam.where({:class_name=>'ah'}).update_all( {:class_name=>'a_h'} )
Spree::SectionPieceParam.where({:class_name=>'ash'}).update_all( {:class_name=>'as_h'} )
