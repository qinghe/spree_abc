post_attribute = Spree::Section.create_section(section_piece_hash['container'], {:title=>"post attribute"}, {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})

post_attribute.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['post-attribute'])
