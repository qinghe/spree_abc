bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#theme preview button
Spree::Section.where(:title=>'preview theme button').each(&:destroy)
theme_related_button = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"preview theme button"},
  {'inner'=>{'15hidden'=>bool_true}})  
theme_related_button.add_section_piece(section_piece_hash['container-link'].id).add_section_piece(section_piece_hash['preview-theme-button'].id)

#new site with selected theme button
Spree::Section.where(:title=>'install theme with site button').each(&:destroy)
theme_related_button = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"install theme with site button"},
  {'inner'=>{'15hidden'=>bool_true}})  
theme_related_button.add_section_piece(section_piece_hash['container-link'].id).add_section_piece(section_piece_hash['install-theme-with-site-button'].id)
