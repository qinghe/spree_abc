
relation_type_name = Spree::Section.create_section( section_piece_hash['container'], {:title=>"relation name"}, \
  { 'block'=>{'21'=>"width:100%",'21unset'=>bool_false} } )
relation_type_name.add_section_piece(section_piece_hash['relation-type-name'])
