#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    alias_method :before_china_address, :before_address

  end
end
