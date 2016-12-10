bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

Spree::Section.where(:title=>'logged&unlogged menu').each(&:destroy)

logged_and_unlogged_menu = Spree::Section.create_section(section_piece_hash['container'], {:title=>"logged&unlogged menu"},
  {'block'=>{'disabled_ha_ids'=>'111'},
   #'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
logged_and_unlogged_menu.add_section_piece(section_piece_hash['logged-and-unlogged-menu']).add_section_piece(section_piece_hash['menuitem'])