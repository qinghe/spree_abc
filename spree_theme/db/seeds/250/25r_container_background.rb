section_piece = find_section_piece('container-background')


inner =  { "editor_id"=>3, "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>1051,  "html_attribute_ids"=>"2,3,4,5"}
create_section_piece_param( section_piece, inner)
inner =  { "editor_id"=>3, "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>1052,  "html_attribute_ids"=>"2,3,4,5"}
create_section_piece_param( section_piece, inner)


container_background = Spree::Section.create_section(section_piece_hash['container'], {:title=>"container background"}, {'block'=>{'21'=>'width:100px','21unset'=>bool_false, 'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})

container_background.add_section_piece(section_piece_hash['container-background'])
