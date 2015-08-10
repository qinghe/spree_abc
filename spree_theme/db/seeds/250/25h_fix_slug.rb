#ActiveRecord::RecordInvalid: Validation failed: Slug has already been taken
Spree::Site.all.each{|site|
  Spree::Site.current = site
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
