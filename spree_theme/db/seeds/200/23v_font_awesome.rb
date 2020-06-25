
post_summary = Spree::Section.create_section(section_piece_hash['container'], {:title=>"bootstrap glyphicon"}, {'inner'=>{'15hidden'=>bool_true}})
  
post_summary.add_section_piece(section_piece_hash['bootstrap-glyphicon'])

  
post_summary = Spree::Section.create_section(section_piece_hash['container'], {:title=>"font awesome"}, {'inner'=>{'15hidden'=>bool_true}})
   
post_summary.add_section_piece(section_piece_hash['font-awesome'])
  
