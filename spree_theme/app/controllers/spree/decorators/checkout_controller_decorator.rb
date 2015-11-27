#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    before_action :associate_terminal

    def associate_terminal
      @order ||= current_order
      if @order
        @order.associate_terminal!(current_terminal) if @order.user_terminal != current_terminal
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
