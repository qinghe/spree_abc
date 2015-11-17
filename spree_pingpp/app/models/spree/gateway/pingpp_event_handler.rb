require "pingpp"
module Spree
  class PingppEventHandler
    attr_accessor :event, :response_body, :status
    def initialize( event )
      self.event = event
      status = 400
      response_body = '' # 可自定义

    end

    def perform
      if event['type'].nil?
        response_body = 'missing Event type'
      elsif event['type'] == 'charge.succeeded'
        charge_succeeded
      elsif event['object'] == 'refund.succeeded'
        # 开发者在此处加入对退款异步通知的处理代码
        status = 200
        response_body = 'OK'
      else
        response_body = 'unkonwn Event type'
      end
      return status, response_body
    end

    def charge_succeeded
      charge = event['data']['object']
      payment = Spree::Payment.find_by_response_code charge['id']

      complete_order payment.order

      self.status = 200
      self.response_body = 'OK'
    end

    def complete_order( order )
        # payment.state always :complete for both service, payment.source store more detail
        # it require pending_payments to process_payments!
        order.complete!
    end

  end
end
