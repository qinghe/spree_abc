#next_post_title
page_attribute = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Next post title"}, {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})  
page_attribute.add_section_piece(section_piece_hash['container-dl']).add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['next-post-title'])
 
#previous_post_title
page_attribute = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Previous post title"}, {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})  
page_attribute.add_section_piece(section_piece_hash['container-dl']).add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['previous-post-title'])
