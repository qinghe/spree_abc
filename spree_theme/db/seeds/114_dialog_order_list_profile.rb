bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}


Spree::Section.where(:title=>'dialog').each(&:destroy)
dialog = Spree::Section.create_section(section_piece_hash['dialog'].id, {:title=>"dialog"})
dialog.add_section_piece(section_piece_hash['container-title'].id)


#order list
Spree::Section.where(:title=>'order list').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"order list"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['order-list'].id)

#profile
Spree::Section.where(:title=>'profile').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"profile"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['profile'].id)