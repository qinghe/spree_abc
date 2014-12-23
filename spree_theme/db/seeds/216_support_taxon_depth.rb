

#table title cell, border,padding
section_piece = find_section_piece 'menuitem'
[16,17,18].each_with_index{|param_category_id, i|
  a =  { "editor_id"=>2,  "class_name"=>"depth#{i+1}", "pclass"=>"css", "param_category_id"=>param_category_id,  "html_attribute_ids"=>"31,32,7,8,6"}
  create_section_piece_param( section_piece, a)

  a =  { "editor_id"=>3, "class_name"=>"depth#{i+1}", "pclass"=>"css", "param_category_id"=>param_category_id,  "html_attribute_ids"=>"2,3,4,5"}
  create_section_piece_param( section_piece, a)

  a =   { "editor_id"=>4,  "class_name"=>"depth#{i+1}", "pclass"=>"css", "param_category_id"=>param_category_id,  "html_attribute_ids"=>"24,27,49,53,54"}  
  create_section_piece_param( section_piece, a)
}