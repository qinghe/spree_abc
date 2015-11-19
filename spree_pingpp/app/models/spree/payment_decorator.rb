Spree::Payment.class_eval do
  # order/payments, payment/processing
  # order.process_payments!  => payment.process!  => handle_payment_preconditions { process_purchase }
  def handle_payment_preconditions(&block)
    unless block_given?
      raise ArgumentError.new("handle_payment_preconditions must be called with a block")
    end

    if payment_method && payment_method.source_required?
      if source
        if !processing?
          if payment_method.supports?(source) || token_based?
            yield
          else
            invalidate!
            raise Core::GatewayError.new(Spree.t(:payment_method_not_supported))
          end
        end
      elsif payment_method.kind_of? Spree::Gateway::PingppBase
        yield
      else
        raise Core::GatewayError.new(Spree.t(:payment_processing_failed))
      end
    end
  end
end
