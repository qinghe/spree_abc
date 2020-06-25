# add html_attribute  border_radius into block, a

transition_duration  = Spree::HtmlAttribute.find_by_css_name 'transition-duration'

spps = Spree::SectionPieceParam.where(:editor_id=>3,:class_name=>'s_a_h')
#container link
spps.each{|spp|
  spp.insert_html_attribute transition_duration
}

spps = Spree::SectionPieceParam.where(:editor_id=>3,:class_name=>'a_h')
#menuitem, product_name
spps.each{|spp|
  spp.insert_html_attribute transition_duration
}
