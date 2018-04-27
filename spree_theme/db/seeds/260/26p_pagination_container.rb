#table title cell, border,padding
section_piece = find_section_piece 'container-pagination'
pagination = {  "editor_id"=>2, "class_name"=>".pagination", "pclass"=>"css", "param_category_id"=>10,  "html_attribute_ids"=>"12,21,15,31,32,7,8,6"}

create_section_piece_param( section_piece, pagination)

a =  { "editor_id"=>2,  "class_name"=>".pagination-.page", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_create_section_piece_param( section_piece, a)
param( section_piece, a)

a =  { "editor_id"=>3, "class_name"=>".pagination-.page", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"2,3,4,5"}
a_h =  { "editor_id"=>3, "class_name"=>".pagination-.page:hover", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"2,3,4,5"}

create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)

a =   { "editor_id"=>4,  "class_name"=>".pagination-.page", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"24,27,49,53,54"}
a_h =  { "editor_id"=>4,  "class_name"=>".pagination-.page:hover", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"24,27,49,53,54"}
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, a_h)


selected = { "editor_id"=>3, "class_name"=>".pagination-.current", "pclass"=>"css", "param_category_id"=>13,  "html_attribute_ids"=>"2,3,4,5"}
create_section_piece_param( section_piece, selected)

selected = { "editor_id"=>4, "class_name"=>".pagination-.current", "pclass"=>"css", "param_category_id"=>13,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}
create_section_piece_param( section_piece, selected)

###########################################################################################
# add section

Spree::Section.where(:title=>'container with pagination').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"container with pagination"},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false,'21'=>'width:100%','21unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash[''container-pagination'])
