include SpreeTheme::SectionPieceParamHelper
#table title cell, border,padding
section_piece = Spree::SectionPiece.find 'container-title'
title =  { "editor_id"=>2, "class_name"=>"s_h6", "pclass"=>"css", "param_category_id"=>6,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, title)
title =  { "editor_id"=>3, "class_name"=>"s_h6", "pclass"=>"css", "param_category_id"=>6,  "html_attribute_ids"=>"2,3,4,5"}
create_section_piece_param( section_piece, title)
title =  { "editor_id"=>4, "class_name"=>"s_h6", "pclass"=>"css", "param_category_id"=>6,  "html_attribute_ids"=>"24,27,49,53,54"}
create_section_piece_param( section_piece, title)


bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

#order_address
Spree::Section.where(:title=>'order address').each(&:destroy)
order_address = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"order address"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_address.add_section_piece(section_piece_hash['container-title'].id)
order_address.add_section_piece(section_piece_hash['order-address'].id)


#order_payment
Spree::Section.where(:title=>'order payment').each(&:destroy)
order_payment = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"order payment"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_payment.add_section_piece(section_piece_hash['container-title'].id)
order_payment.add_section_piece(section_piece_hash['order-payment'].id)


#order_items
Spree::Section.where(:title=>'order items').each(&:destroy)
order_items = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"order items"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
order_items.add_section_piece(section_piece_hash['container-title'].id)
order_items.add_section_piece(section_piece_hash['order-items'].id)
