
# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>4,:class_name=>'block').all

if spps.size == 1
  text_transform = Spree::HtmlAttribute.find 56   #text-transform
  text_indent = Spree::HtmlAttribute.find 55  #text-indent
  spps.first.insert_html_attribute text_indent, text_transform  
end

