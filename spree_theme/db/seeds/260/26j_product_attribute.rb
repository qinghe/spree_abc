product_attribute = Spree::Section.create_section(section_piece_hash['container'], {:title=>"product attribute"}, {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})

product_attribute.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['product-attribute'])
