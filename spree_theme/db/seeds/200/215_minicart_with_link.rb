bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

minicart = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Mini cart2"},
  {'block'=>{'disabled_ha_ids'=>'111'},
   #'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
minicart.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['minicart'])
