bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#add product_quantity
Spree::Section.where(:title=>'product quantity').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"product quantity"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['product_quantity'].id)

#add product_atc
Spree::Section.where(:title=>'product atc').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"product atc"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['product_atc'].id)