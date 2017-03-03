#ActiveRecord::RecordInvalid: Validation failed: Slug has already been taken
# it would cause error while spree_theme:reload, there is no FakeWebsite table.
SpreeTheme.site_class.all.each{|site|
  SpreeTheme.site_class.current = site
  site.products.each{|product|
    unless product.valid?
      puts "#{product.id} #{product.errors.messages}"
      product.price = 1 if product.errors.get :price
      product.sku = "sku#{rand(10)}" if product.errors.get :sku
      product.slug = nil if product.errors.get :slug
      #unless product.valid?
      #  puts "#{product.id}, invalid, #{product.errors.messages}"
      #end
      product.save!
    end
  }
}
