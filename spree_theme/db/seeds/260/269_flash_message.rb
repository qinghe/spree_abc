#flash message
#Spree::Section.where(:title=>'absolute container').each(&:destroy)
flash_message = Spree::Section.create_section( section_piece_hash['container'], {:title=>"flash message"}, \
  { 'block'=>{'21'=>"width:100%",'21unset'=>bool_false} } )
flash_message.add_section_piece(section_piece_hash['flash-message'])
