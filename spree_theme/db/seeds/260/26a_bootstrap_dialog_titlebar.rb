section_piece = find_section_piece 'bootstrap-dialog-titlebar'
unless section_piece.section_piece_params.exists?( :class_name=>'dialog_titlebar' )
  titlebar =  { "editor_id"=>2,  "class_name"=>"dialog_titlebar", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"31,32,7,8,6"}
  create_section_piece_param( section_piece, titlebar)

  titlebar =  { "editor_id"=>3, "class_name"=>"dialog_titlebar", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"2,3,4,5"}
  create_section_piece_param( section_piece, titlebar)

  titlebar =   { "editor_id"=>4,  "class_name"=>"dialog_titlebar", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"24,27,49,53,54"}
  create_section_piece_param( section_piece, titlebar)
end

section_piece.section_piece_params.where(['editor_id=? and class_name=?',2,'dialog_titlebar']).each{|spp|
  spp.section_params.each{|sp|
    sp.add_default_value( '32','padding:2px 2px 2px 2px')
    sp.add_default_value('32unset',bool_false)
  }
}
section_piece.section_piece_params.where(['editor_id=? and class_name=?',3,'dialog_titlebar']).each{|spp|
  spp.section_params.each{|sp|
    sp.add_default_value( '2','background-color:#EEEEEE')
    sp.add_default_value('2unset',bool_false)
  }
}
