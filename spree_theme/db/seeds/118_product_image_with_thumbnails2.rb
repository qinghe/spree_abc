#add product_image_with_thumbnails
bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

Spree::Section.where(:title=>'product image with thumbnails2').each(&:destroy)
product_image_with_thumbnails = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"product image with thumbnails2"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})  
product_image_with_thumbnails.add_section_piece(section_piece_hash['product_main_image'].id)
product_image_with_thumbnails.add_section_piece(section_piece_hash['product_thumbnails'].id)
