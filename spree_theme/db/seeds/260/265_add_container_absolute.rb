
#table title cell, border,padding
section_piece = find_section_piece 'container-absolute'
absolute_position =  { "editor_id"=>2, "class_name"=>"absolute_position", "pclass"=>"css", "param_category_id"=>7,  "html_attribute_ids"=>"41,40,33,35"}
unless section_piece.section_piece_params.where(:class_name=>'absolute_position').any?
  create_section_piece_param( section_piece, absolute_position)
end


#absolute_container
#Spree::Section.where(:title=>'absolute container').each(&:destroy)
absolute_container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"absolute container"},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'21'=>"width:100px",'21unset'=>bool_false,'15'=>"height:100px",'15unset'=>bool_false,'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'2'=>'background-color:silver','2unset'=>bool_false,'15hidden'=>bool_true}}
)
absolute_container.add_section_piece(section_piece_hash['container-absolute'])
