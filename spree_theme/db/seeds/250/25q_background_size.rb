# add html_attribute  border_radius into block, a

background_size = Spree::HtmlAttribute.find_by_css_name 'background-size'

spps = Spree::SectionPieceParam.where(:editor_id=>3,:class_name=>'inner')
#container, bootstrap_container, root_for_mobile
if spps.size == 3
  spps.each{|spp|
    spp.insert_html_attribute background_size
  }
end
