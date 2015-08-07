SpreeTheme.site_class.all.each{|site|
  SpreeTheme.site_class.current = site
  Spree::Taxon.where( depth: 3 ).each { |t| t.save }
}
