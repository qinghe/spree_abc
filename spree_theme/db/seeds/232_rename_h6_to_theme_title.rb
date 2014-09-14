
# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:class_name=>'s_h6').all

if spps.size >0
  spps.each{|spp|
    spp.class_name = 's_theme_title'
    spp.save!
  }
end

