# add html_attribute  border_radius into block, a
spps = Spree::SectionPieceParam.where(:section_piece_id=>2, :editor_id=>2,:class_name=>'inner').all

border_radius = Spree::HtmlAttribute.find_by_css_name 'border-radius'
border_color =  Spree::HtmlAttribute.find_by_css_name 'border-color'

if spps.size == 1
  spps.first.insert_html_attribute border_radius, border_color
end


spps = Spree::SectionPieceParam.where(:editor_id=>2,:class_name=>'a').all

if spps.size == 1
  spps.first.insert_html_attribute border_radius, border_color
end
