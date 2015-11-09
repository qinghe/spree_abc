#encoding: utf-8
module Spree
  OrdersController.class_eval do
    before_action :associate_terminal
  # action :update, :edit, :show, :populate support ajax
    respond_to :html, :js

    def associate_terminal
      @order ||= current_order
      if @order
        @order.associate_terminal!(current_terminal) if @order.user_terminal.blank?
      end
    end
  end
end
