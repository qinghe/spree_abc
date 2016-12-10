bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Taxon description"},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['taxon-description'])