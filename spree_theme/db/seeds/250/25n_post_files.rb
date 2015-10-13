post_files = Spree::Section.create_section(section_piece_hash['container'], {:title=>"post files"}, {'block'=>{'21'=>'width:100px','21unset'=>bool_false, 'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})

post_files.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['post-files'])
