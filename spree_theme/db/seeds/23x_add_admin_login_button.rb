bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#admin_login_button
Spree::Section.where(:title=>'admin login button').each(&:destroy)
theme_related_button = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"admin login button"},
  {'inner'=>{'15hidden'=>bool_true}})  
theme_related_button.add_section_piece(section_piece_hash['container-link'].id).add_section_piece(section_piece_hash['admin-login-button'].id)

