sections = Spree::Section.where(['title in (?)',['center_area','left_part','right_part','center_part']]).roots
if sections.any?
  sections.each{|section| section.update_attribute(:is_enabled, false)}
end
