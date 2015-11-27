module Spree
  module CheckoutHelper

    def order_states
      %w{ address delivery payment confirm }
    end

    def step_class state
      state = 'disabled-step' unless @order.send("#{state}?")
      %Q|checkout-content #{state}|
    end

    def confirm? state
      state == 'confirm'
    end
  end
end

