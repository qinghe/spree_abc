Spree::Section.where(:title=>'Mini cart').each{|section|
  section.update_attribute( :is_enabled, false )  
}