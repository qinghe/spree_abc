bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

#ship_form
Spree::Section.where(:title=>'ship form').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"ship form"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['ship-form'].id)

#payment_form
Spree::Section.where(:title=>'payment form').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"payment form"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['payment-form'].id)
