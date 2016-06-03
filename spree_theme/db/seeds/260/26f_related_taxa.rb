# taxon previous attribute
section = Spree::Section.create_section( section_piece_hash['container'], \
  { title: "taxon previous attribute", content_param: 1}, \
  { 'block'=>{'21'=>"width:100%",'21unset'=>bool_false} } )
section.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['taxon-previous-attribute'])


# taxon next attribute
section = Spree::Section.create_section( section_piece_hash['container'], \
  {title: "taxon next attribute", content_param: 1}, \
  { 'block'=>{'21'=>"width:100%",'21unset'=>bool_false} } )
section.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['taxon-next-attribute'])
