module Spree
  # helpers
  module Gateway::PingppHelper

    def get_order_by_charge( charge )
      Spree::Order.find_by_number( charge['order_no'] )
    end

    def get_payment_by_order( order )
      order.payments.last
    end

    def complete_order( order )
      order.next
    end

    def get_order_by_gateway_options( gateway_options )
      gateway_order_id = gateway_options[:order_id]
    end

  end
end
