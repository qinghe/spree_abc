#encoding: utf-8
module Spree
  OrdersController.class_eval do
     respond_to :html, :js    
  end
end