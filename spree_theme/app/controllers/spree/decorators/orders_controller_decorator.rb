#encoding: utf-8
module Spree
  OrdersController.class_eval do
  # action :update, :edit, :show, :populate support ajax
    respond_to :html, :js
  end
end
