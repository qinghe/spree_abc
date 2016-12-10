#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    before_filter :payment_pingpp_hook, :only => [:update]

    def payment_pingpp_hook
      @pingpp_base_class = Spree::Gateway::PingppBase

      return unless @order.next_step_complete?
      #in confirm step, only param is  {"state"=>"confirm"}
      payment_method = get_payment_method_by_params(  )
      if payment_method.kind_of?( @pingpp_base_class )
        handle_pingpp( payment_method )
      end
    end

    # handle all supported billing_integration
    def handle_pingpp( payment_method )
      if @order.update_from_params( params, permitted_checkout_attributes, request.headers.env )
        pingpp_channel = params['payment_pingpp'][payment_method.id.to_s]
          #more flow detail
          #https://pingxx.com/guidance/products/sdk
          payment_provider = payment_method.provider
          #please try with host 127.0.0.1 instead localhost, or get invalid url http://localhost:3000/...
          #order_path( order, :only_path => false )
          begin
            @charge = payment_provider.create_charge( @order, pingpp_channel, spree.pingpp_charge_done_path( :only_path => false ) )
            #redirect_to payment_provider.get_payment_url( charge )
            #render json: charge
            render( :payment_pingpp_dispatch ) and return
          rescue Pingpp::PingppError => error
            Rails.logger.error error
            redirect_to checkout_state_path( @order.state )
          end
      else
        render( :edit ) and return
      end
    end

    private

    def get_payment_method_by_params
      payment_method_id = params[:order].try(:[],:payments_attributes).try(:first).try(:[],:payment_method_id).to_i
      Spree::PaymentMethod.find_by_id(payment_method_id)
    end

  end
end
