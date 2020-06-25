Spree::Section.roots.each{|section|
  case section.title
    when /Logo/
      section.usage = 'logo'
    when /Mini cart/
      section.usage = 'minicart'
  end
  section.save!
}
