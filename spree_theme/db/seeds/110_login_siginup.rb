
section_piece = Spree::SectionPiece.find 'container-title'
html_attribute = Spree::HtmlAttribute.find 'font-weight'
default_value = "font-weight:bold"
section_piece_param = section_piece.section_piece_params.where(["editor_id=?",4]).first

if section_piece_param.html_attributes.include? html_attribute
  section_piece_param.section_params.each{|section_param|
    section_param.add_default_value(html_attribute.id, default_value)
  }
end



bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

#login_form
Spree::Section.where(:title=>'login form').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"login form"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['login-form'].id)

#sign_up_form
Spree::Section.where(:title=>'sign up form').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"sign up form"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['sign-up-form'].id)
