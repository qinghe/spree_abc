hmenu = Spree::Section.create_section(section_piece_hash['container'], {:title=>"hmenu with vertical submenu"},
 { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})


hmenu.add_section_piece(section_piece_hash['container-hmenu-with-vertical-submenu']).add_section_piece(section_piece_hash['hmenu']).add_section_piece(section_piece_hash['menuitem'])
