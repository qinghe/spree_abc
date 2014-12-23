bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#add product_image_with_thumbnails
Spree::Section.where(:title=>'product image with thumbnails').each(&:destroy)
product_image_with_thumbnails = Spree::Section.create_section(section_piece_hash['container'], {:title=>"product image with thumbnails"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
  
product_image_with_thumbnails.add_section_piece(section_piece_hash['container'], {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}}).add_section_piece(section_piece_hash['product_main_image'])
product_image_with_thumbnails.reload
product_image_with_thumbnails.add_section_piece(section_piece_hash['container'], {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}}).add_section_piece(section_piece_hash['product_thumbnails'])


#add product_properties
Spree::Section.where(:title=>'product_properties').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'], {:title=>"product properties"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['product_properties'])

#add product_price
Spree::Section.where(:title=>'product_price').each(&:destroy)
product_properties = Spree::Section.create_section(section_piece_hash['container'], {:title=>"product price"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
product_properties.add_section_piece(section_piece_hash['product_price'])