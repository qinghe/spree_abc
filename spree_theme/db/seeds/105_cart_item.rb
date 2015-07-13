bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#cart items
Spree::Section.where(:title=>'cart items').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"cart items"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['cart-items'].id)

#order_total_price
Spree::Section.where(:title=>'order total price').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"order total price"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['order-total-price'].id)
