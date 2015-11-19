require "pingpp"
module Spree
  class Gateway::PingppEventHandler
    include Gateway::PingppHelper

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
      order = get_order_by_charge charge
      if order
        complete_order order
      end
      self.status = 200
      self.response_body = 'OK'
    end

  end
end
