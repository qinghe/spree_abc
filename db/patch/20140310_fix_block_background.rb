spp = Spree::SectionPieceParam.where(:section_piece_id=>2, :editor_id=>3, :class_name=>"block").first
if spp
  spp.update_attribute(:class_name, "inner")
end
