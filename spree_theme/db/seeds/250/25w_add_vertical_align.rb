# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>4,:class_name=>'s_cell')

if spps.size == 1
  vertical_align = Spree::HtmlAttribute.find 42
  spps.first.insert_html_attribute vertical_align
else
  raise 'more than one section piece param named td and editor is 4'
end
