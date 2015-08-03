Spree::Site.all.each{|site|
  Spree::Site.current = site
  Spree::Taxon.where( depth: 3 ).each { |t| t.save }
}
