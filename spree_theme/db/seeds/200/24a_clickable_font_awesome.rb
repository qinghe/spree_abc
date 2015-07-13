post_summary = Spree::Section.create_section(section_piece_hash['container'], {:title=>"font awesome plus"}, {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})
   
post_summary.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['font-awesome'])
  
