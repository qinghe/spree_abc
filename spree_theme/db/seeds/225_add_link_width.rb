
# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>2,:class_name=>'a').all

if spps.size == 1
  margin = Spree::HtmlAttribute.find 31   #text-transform
  width = Spree::HtmlAttribute.find 21  #text-indent
  spps.first.insert_html_attribute width, margin  
end

# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>2,:class_name=>'s_a').all

if spps.size == 1
  margin = Spree::HtmlAttribute.find 31   #text-transform
  width = Spree::HtmlAttribute.find 21  #text-indent
  spps.first.insert_html_attribute width, margin  
end

