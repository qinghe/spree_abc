bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#order number
Spree::Section.where(:title=>'order number').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"order number"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['order-number'].id)

#