spps = Spree::SectionPieceParam.where(:editor_id=>3,:class_name=>'s_a').all

if spps.size == 1
  bgsize = Spree::HtmlAttribute.find 117   #background-size
  spps.first.insert_html_attribute bgsize
end
