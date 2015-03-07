Spree::Section.where(:title=>'Bootstrap container').each(&:destroy)


bootstrap_container = Spree::Section.create_section(section_piece_hash['bootstrap-container'], {:title=>"Bootstrap container"})


Spree::Section.where(:title=>'Bootstrap column').each(&:destroy)


bootstrap_column = Spree::Section.create_section(section_piece_hash['bootstrap-column'], {:title=>"Bootstrap column"})
