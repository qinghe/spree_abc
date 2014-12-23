bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}


#cart
Spree::Section.where(:title=>'cart').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'], {:title=>"cart"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['cart'])

#account
Spree::Section.where(:title=>'account').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'], {:title=>"account"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['account'])