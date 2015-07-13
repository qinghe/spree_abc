#encoding: utf-8
shipping_method = Spree::ShippingMethod.find_by_name("顺丰 Ground")
shipping_method.calculator.preferred_amount = 15

# flat_rate_five_dollars:
#   name: amount
#   owner: flat_rate_coupon_calculator
#   owner_type: Spree::Calculator
#   value: 5
