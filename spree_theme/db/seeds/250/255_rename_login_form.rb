Spree::Section.where(title:'login form').each{|section|
  section.title = 'sign in form'
  section.slug = 'sign-in-form'
  section.save!
}
