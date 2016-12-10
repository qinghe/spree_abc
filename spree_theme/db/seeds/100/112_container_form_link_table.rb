

#table title cell, border,padding
section_piece = find_section_piece 'container-link'

a =  { "editor_id"=>2,  "class_name"=>"s_a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, a)

a =  { "editor_id"=>3, "class_name"=>"s_a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"2,3,4,5"}
a_h =  { "editor_id"=>3, "class_name"=>"s_a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"2,3,4,5"}  

create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)

a =   { "editor_id"=>4,  "class_name"=>"s_a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"24,27,49,53,54"}  
a_h =  { "editor_id"=>4,  "class_name"=>"s_a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)



#table title cell, border,padding
section_piece = find_section_piece 'container-table'
  
table = {"editor_id"=>2, "class_name"=>"s_table", "pclass"=>"css", "param_category_id"=>78,  "html_attribute_ids"=>"31,7,8,6"}
cell = {"editor_id"=>2, "class_name"=>"s_cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"32,7,8,6"}

create_section_piece_param( section_piece, table)
create_section_piece_param( section_piece, cell)

cell =  { "editor_id"=>3,  "class_name"=>"s_cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"2,3,4,5"}  
th =  { "editor_id"=>3,  "class_name"=>"s_th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"2,3,4,5"}  
td =  { "editor_id"=>3,  "class_name"=>"s_td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, cell)
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)

cell = { "editor_id"=>4,  "class_name"=>"s_cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"24,27,49,53,54"}  
th = { "editor_id"=>4,  "class_name"=>"s_th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"24,27,49,53,54"}  
td = { "editor_id"=>4,  "class_name"=>"s_td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, cell)
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)

# form label error input
section_piece = find_section_piece 'container-form'

form = {"editor_id"=>2, "class_name"=>"s_form", "pclass"=>"css", "param_category_id"=>39,  "html_attribute_ids"=>"31,7,8,6"}
label = {"editor_id"=>2, "class_name"=>"s_label", "pclass"=>"css", "param_category_id"=>42,  "html_attribute_ids"=>"31,32,7,8,6"}
error = {"editor_id"=>2, "class_name"=>"s_error", "pclass"=>"css", "param_category_id"=>43,  "html_attribute_ids"=>"31,32,7,8,6"}
input = { "editor_id"=>2,  "class_name"=>"s_input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"21,15,31,32,7,8,6"}  
create_section_piece_param( section_piece, form)
create_section_piece_param( section_piece, label)
create_section_piece_param( section_piece, error)
create_section_piece_param( section_piece, input)

label = {"editor_id"=>3, "class_name"=>"s_label", "pclass"=>"css", "param_category_id"=>42,  "html_attribute_ids"=>"2,3,4,5"}
error = {"editor_id"=>3, "class_name"=>"s_error", "pclass"=>"css", "param_category_id"=>43,  "html_attribute_ids"=>"2,3,4,5"}
input = { "editor_id"=>3,  "class_name"=>"s_input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, label)
create_section_piece_param( section_piece, error)
create_section_piece_param( section_piece, input)

label = {"editor_id"=>4, "class_name"=>"s_label", "pclass"=>"css", "param_category_id"=>42,  "html_attribute_ids"=>"24,27,49,53,54"}
error = {"editor_id"=>4, "class_name"=>"s_error", "pclass"=>"css", "param_category_id"=>43,  "html_attribute_ids"=>"24,27,49,53,54"}
input = { "editor_id"=>4,  "class_name"=>"s_input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, label)
create_section_piece_param( section_piece, error)
create_section_piece_param( section_piece, input)