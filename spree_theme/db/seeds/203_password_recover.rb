bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

#login_form
Spree::Section.where(:title=>'password recover form').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'], {:title=>"password recover form"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'])
order_address.add_section_piece(section_piece_hash['password-recover-form'])

