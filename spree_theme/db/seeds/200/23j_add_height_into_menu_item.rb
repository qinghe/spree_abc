# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>2,:class_name=>'a').all

if spps.size == 1
  margin = Spree::HtmlAttribute.find 31  #margin
  height = Spree::HtmlAttribute.find 15  #height
  spps.first.insert_html_attribute height, margin
end
