
Spree::Section.where(:title=>'root for mobile').each(&:destroy)
root_for_terminal = Spree::Section.create_section(section_piece_hash['root-for-mobile'], {:title=>"root for mobile"})


