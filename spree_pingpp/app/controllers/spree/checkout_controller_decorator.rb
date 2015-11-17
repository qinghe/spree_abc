#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    #before_filter :checkout_hook, :only => [:update]

    # handle all supported billing_integration
    def handle_pingpp
      @pingpp_base_class = Spree::Gateway::PingppBase
      if @order.update_from_params( params, permitted_checkout_attributes, request.headers.env )
        pingpp_channel = params['payment_pingpp_channel']
        payment_method = get_payment_method(  )
        if payment_method.kind_of?(@pingpp_base_class)
          #more flow detail
          #https://pingxx.com/guidance/products/sdk
          payment_provider = payment_method.provider
          #please try with host 127.0.0.1 instead localhost, or get invalid url http://localhost:3000/...
          #order_path( order, :only_path => false )
          charge = payment_provider.create_charge( @order, pingpp_channel, spree.pingpp_charge_done_path( :only_path => false ) )
          render json: charge
        end
      else
        render( :edit ) and return
      end
    end

    private

    def get_payment_method(  )
      @order.unprocessed_payments.first.try(:payment_method)
    end

  end
end
