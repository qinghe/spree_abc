# add html_attribute  border_radius into block, a

border_color =  Spree::HtmlAttribute.find_by_css_name 'border-color'
border_radius = Spree::HtmlAttribute.find_by_css_name 'border-radius'

spps = Spree::SectionPieceParam.where(:editor_id=>2,:class_name=>['s_a','s_button','s_input'])

if spps.size == 3
  spps.each{|spp|
    spp.insert_html_attribute border_radius, border_color
  }
end
