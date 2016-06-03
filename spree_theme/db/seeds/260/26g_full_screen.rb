
# taxon next attribute
section = Spree::Section.create_section( section_piece_hash['container'], \
  { title: "full screen" }, \
  {'block'=>{'disabled_ha_ids'=>'15,21'}})
section.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['full-screen'])
