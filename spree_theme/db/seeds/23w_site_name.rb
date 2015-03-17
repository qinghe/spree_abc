post_summary = Spree::Section.create_section(section_piece_hash['container'], {:title=>"site title"}, {'inner'=>{'15hidden'=>bool_true}})
   
post_summary.add_section_piece(section_piece_hash['site-title'])
