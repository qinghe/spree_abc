#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    # Updates the order and advances to the next state (when possible.)
    def update
Rails.logger.debug "zz-->before update=#{@order.state}"
      if @order.update_attributes(object_params)
        fire_event('spree.checkout.update')

Rails.logger.debug "zz-->before next=#{@order.state},#{@order.shipments}"
        while(@order.next) do
Rails.logger.debug "zz-->order.state=#{@order.state}"
          if pay_by_billing_integration?
            break
          end
        end
Rails.logger.debug "zz-->#{@order.errors.inspect}"        
Rails.logger.debug "zz-->pay_by_billing_integration?=#{pay_by_billing_integration?}"        
        if pay_by_billing_integration?
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
    

  end
end
