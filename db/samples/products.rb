#encoding: utf-8
#Spree::Sample.load_sample("tax_categories")
#Spree::Sample.load_sample("shipping_categories")

clothing = Spree::TaxCategory.find_by_name!("Clothing")
shipping_category = Spree::ShippingCategory.find_by_name!("缺省")

default_attrs = {
  :description => Faker::Lorem.paragraph,
  :available_on => Time.zone.now
}

products = [
  {
    :name => "加维克台灯", #Ruby on Rails Tote
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 15.99,
    :eur_price => 14,
  },
  {
    :name => "卡秋塔台灯", #Ruby on Rails Bag
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 22.99,
    :eur_price => 19,
  },
  {
    :name => "代德杯子", #Ruby on Rails Baseball Jersey
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "奥米欧茶壶",#Ruby on Rails Jr. Spaghetti
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16

  },
  {
    :name => "莱思比茶杯",#Ruby on Rails Ringer T-Shirt
    :shipping_category => shipping_category,
    :tax_category => clothing,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "哈里大杯", #Ruby Baseball Jersey
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "盖尔杯碟",
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "斯德哥尔摩意式咖啡杯", #Spree Baseball Jersey
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "沃格特茶滤", #Spree Jr. Spaghetti
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "昂顿大杯", #Spree Ringer T-Shirt
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 19.99,
    :eur_price => 16
  },
  {
    :name => "维迪亚台灯", #Spree Tote
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 15.99,
    :eur_price => 14,
  },
  {
    :name => "克劳比工作灯",
    :tax_category => clothing,
    :shipping_category => shipping_category,
    :price => 22.99,
    :eur_price => 19
  },
  {
    :name => "布朗达布兰科上菜用碗",#Ruby on Rails Mug
    :shipping_category => shipping_category,
    :price => 13.99,
    :eur_price => 12
  },
  {
    :name => "巴尔巴托盘", #Ruby on Rails Stein
    :shipping_category => shipping_category,
    :price => 16.99,
    :eur_price => 14
  },
  {
    :name => "弗斯拉碗", #Spree Stein
    :shipping_category => shipping_category,
    :price => 16.99,
    :eur_price => 14,
  },
  {
    :name => "奥芬利托盘", #Spree Mug
    :shipping_category => shipping_category,
    :price => 13.99,
    :eur_price => 12
  }
]

products.each do |product_attrs|
  eur_price = product_attrs.delete(:eur_price)
  #Spree::Config[:currency] = "USD"

  #default_shipping_category = Spree::ShippingCategory.find_by_name!("缺省")
  product = Spree::Product.create!(default_attrs.merge(product_attrs)) do |prod|
    prod.slug  = nil # friendly_id 5.0 required
  end
  #Spree::Config[:currency] = "EUR"
  #product.reload
  #product.price = eur_price
  #product.shipping_category = default_shipping_category
  #product.save!
end

#Spree::Config[:currency] = "USD"
