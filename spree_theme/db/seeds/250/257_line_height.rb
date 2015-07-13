# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>4,:class_name=>'block').all

if spps.size == 1
  letter_space = Spree::HtmlAttribute.find 52
  line_height = Spree::HtmlAttribute.find 16  #height
  spps.first.insert_html_attribute line_height, letter_space
else
  raise 'more than one section piece param named block and editor is 4'
end
