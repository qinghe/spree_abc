logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Product search"},
  {'block'=>{'disabled_ha_ids'=>'111'},
   #'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['container-form']).add_section_piece(section_piece_hash['product-search'])
