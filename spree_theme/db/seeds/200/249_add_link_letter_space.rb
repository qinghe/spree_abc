# add html_attribute letter_space into container
spps = Spree::SectionPieceParam.where(:editor_id=>4,:class_name=>'s_a').all

if spps.size == 1
  text_align = Spree::HtmlAttribute.find 53 
  letter_space = Spree::HtmlAttribute.find 52  
  spps.first.insert_html_attribute letter_space,text_align
end