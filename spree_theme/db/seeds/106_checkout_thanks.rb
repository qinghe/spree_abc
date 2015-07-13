bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#checkout
Spree::Section.where(:title=>'checkout').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"checkout"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['checkout'].id)

#thanks
Spree::Section.where(:title=>'thanks').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"thanks"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['thanks'].id)
