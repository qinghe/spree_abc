# add html_attribute letter_space into container
spps = Spree::SectionPieceParam.where(:editor_id=>4,:class_name=>['td','th']).all

if spps.size == 2
  spps.each{|spp|
    text_align = Spree::HtmlAttribute.find 53 
    vertical_align = Spree::HtmlAttribute.find 42  
    spp.insert_html_attribute vertical_align,text_align    
  }
end