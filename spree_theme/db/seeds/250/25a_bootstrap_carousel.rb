
carousel = Spree::Section.create_section(section_piece_hash['container'], {:title=>"product image carousel"}, {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})
carousel.add_section_piece(section_piece_hash['bootstrap-carousel'])
