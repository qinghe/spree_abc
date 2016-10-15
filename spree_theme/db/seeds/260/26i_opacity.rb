# add html_attribute margin into a
opacity = Spree::HtmlAttribute.find_by_css_name 'opacity'

spps = Spree::SectionPieceParam.where(:editor_id=>3,:class_name=>'inner')
#container, bootstrap_container, root_for_mobile
#if spps.size == 3
  spps.each{|spp|
    spp.insert_html_attribute opacity
  }
#end
