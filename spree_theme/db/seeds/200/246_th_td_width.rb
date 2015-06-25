section_piece = find_section_piece 'product_properties'

th = { "editor_id"=>2,  "class_name"=>"th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"21"}  
td = { "editor_id"=>2,  "class_name"=>"td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"21"}  
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)