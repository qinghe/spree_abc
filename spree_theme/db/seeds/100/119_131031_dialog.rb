

bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE

section_piece = find_section_piece 'dialog-title'
unless section_piece.section_piece_params.exists?( :class_name=>'title' )
  title =  { "editor_id"=>2,  "class_name"=>"title", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"31,32,7,8,6"}
  create_section_piece_param( section_piece, title)

  title =  { "editor_id"=>3, "class_name"=>"title", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"2,3,4,5"}
  create_section_piece_param( section_piece, title)

  title =   { "editor_id"=>4,  "class_name"=>"title", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"24,27,49,53,54"}
  create_section_piece_param( section_piece, title)
end

section_piece.section_piece_params.where(['editor_id=? and class_name=?',2,'title']).each{|spp|
  spp.section_params.each{|sp|
    sp.add_default_value(32,'padding:2px 2px 2px 2px')
    sp.add_default_value('32unset',bool_false)
  }
}
section_piece.section_piece_params.where(['editor_id=? and class_name=?',3,'title']).each{|spp|
  spp.section_params.each{|sp|
    sp.add_default_value(2,'background-color:#EEEEEE')
    sp.add_default_value('2unset',bool_false)
  }
}


section_piece = find_section_piece 'dialog-content'
unless section_piece.section_piece_params.exists?( :class_name=>'inner' )
  content =  { "editor_id"=>2,  "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>5,  "html_attribute_ids"=>"31,32"}
  create_section_piece_param( section_piece, content)
end
section_piece.section_piece_params.where(['editor_id=? and class_name=?',2,'inner']).each{|spp|
  spp.section_params.each{|sp|
    sp.add_default_value(32,'padding:0 10px 5px 10px')
    sp.add_default_value('32unset',bool_false)
  }
}
