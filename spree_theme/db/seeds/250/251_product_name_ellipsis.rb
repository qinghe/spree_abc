product_name = Spree::Section.create_section(section_piece_hash['container'], {:title=>"product name with ellipsis"}, {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})
   
product_name.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['product-name-with-ellipsis'])
