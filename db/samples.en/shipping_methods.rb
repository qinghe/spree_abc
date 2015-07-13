#encoding: utf-8

china = Spree::Zone.find_by_name!('中国')
shipping_category = Spree::ShippingCategory.find_or_create_by_name!('缺省')

shipping_methods = [
  {
    :name => "顺丰 Ground",
    :zones => [china],
    :calculator => Spree::Calculator::FlatRate.create!,
    :shipping_categories => [shipping_category]
  }]

shipping_methods.each do |shipping_method_attrs|
  Spree::ShippingMethod.create!(shipping_method_attrs, :without_protection => true)
end

{
  "顺丰 Ground" => [5, "CNY"]
}.each do |shipping_method_name, (price, currency)|
  shipping_method = Spree::ShippingMethod.find_by_name!(shipping_method_name)
  shipping_method.calculator.preferred_amount = price
  shipping_method.calculator.preferred_currency = currency
  shipping_method.shipping_categories << shipping_category
  shipping_method.save!
end

