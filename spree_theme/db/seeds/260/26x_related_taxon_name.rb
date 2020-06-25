
related_taxon_name = Spree::Section.create_section( section_piece_hash['container'], {:title=>"related taxon name"}, \
  { 'block'=>{'21'=>"width:100%",'21unset'=>bool_false} } )
related_taxon_name.add_section_piece(section_piece_hash['related-taxon-name'])
