#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    # Updates the order and advances to the next state (when possible.)
    def update_unused
      if @order.update_attributes(object_params)
        fire_event('spree.checkout.update')

        while(@order.next) do
          if pay_with_billing_integration?
            break
          end
        end
        #since update is override, call it explicitly for alipay 
        if pay_with_billing_integration?
          handle_billing_integration
          return
        end
        
        unless @order.completed?
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to checkout_state_path(@order.state) and return
        end

        if @order.completed?
          session[:order_id] = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash[:commerce_tracking] = "nothing special"
          redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        render :edit
      end
    end
    private
    # For payment step, filter order parameters to produce the expected nested
    # attributes for a single payment and its source, discarding attributes
    # for payment methods other than the one selected
    def object_params
      # respond_to check is necessary due to issue described in #2910
      if params[:payment_source].present?
        source_params = params.delete(:payment_source)[params[:order][:payments_attributes].first[:payment_method_id].underscore]

        if source_params
          params[:order][:payments_attributes].first[:source_attributes] = source_params
        end
      end

      if (params[:order][:payments_attributes])
        params[:order][:payments_attributes].first[:amount] = @order.total
      end
      params[:order]
    end
    
    def pay_with_billing_integration?
      if @order.next_step_complete?
        if @order.pending_payments.first.payment_method.kind_of? BillingIntegration 
          return true
        end
      end
      return false
    end
  end
end
