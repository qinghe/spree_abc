#cart items for mobile
Spree::Section.where(:title=>'cart items for mobile').each(&:destroy)
cart_items_for_mobile = Spree::Section.create_section(section_piece_hash['container'], {:title=>"cart items"},
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}})
cart_items_for_mobile.add_section_piece(section_piece_hash['cart-items-for-mobile'])
