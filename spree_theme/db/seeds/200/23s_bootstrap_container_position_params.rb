section_piece = find_section_piece 'bootstrap-column'
block = {"editor_id"=>2, "class_name"=>"block", "pclass"=>"css", "param_category_id"=>2,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, block)

section_piece = find_section_piece 'bootstrap-container'

inner = {"editor_id"=>2, "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>2,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, inner)

inner =  { "editor_id"=>3, "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>2,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, inner)

inner =   { "editor_id"=>4,  "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>2,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, inner)
