module Spree
  module CheckoutHelper
    def wrapper_class state
      klass = confirm?(state) && 'omega sixteen' || 'twelve'
      %Q|columns alpha form-wrapper #{klass}|
    end

    def order_states
      %w{ address delivery payment confirm }
    end

    def step_class state
      state = 'disabled-step' unless @order.send("#{state}?")
      %Q|row checkout-content #{state}|
    end

    def confirm? state
      state == 'confirm'
    end
  end
end

