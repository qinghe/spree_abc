# add html_attribute  border_radius into block, a

color =  Spree::HtmlAttribute.find_by_css_name 'color'
line_height =  Spree::HtmlAttribute.find_by_css_name 'line-height'
letter_spacing = Spree::HtmlAttribute.find_by_css_name 'letter-spacing'

spps = Spree::SectionPieceParam.where(:editor_id=>4,:class_name=>'s_header3')

if spps.size == 1
  spps.each{|spp|
    spp.insert_html_attribute line_height,color
    spp.insert_html_attribute letter_spacing
  }
end
