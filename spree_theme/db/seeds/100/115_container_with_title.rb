bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

#container-title
Spree::Section.where(:title=>'container with title').each(&:destroy)
container = Spree::Section.create_section(section_piece_hash['container'], {:title=>"container with title"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
container.add_section_piece(section_piece_hash['container-title'])
