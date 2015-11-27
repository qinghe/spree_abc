Spree::Section.where(title:'cart').each{|section|
  section.title = 'cart form'
  section.slug = 'cart-form'
  section.save!
}
Spree::Section.where(title:'checkout').each{|section|
  section.title = 'checkout form'
  section.slug = 'checkout-form'
  section.save!
}
