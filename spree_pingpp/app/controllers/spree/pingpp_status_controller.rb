#inspired by https://github.com/spree-contrib/spree_skrill
module Spree
  class PingppStatusController < StoreController
    include Gateway::PingppHelper

    #fixes Action::Controller::InvalidAuthenticityToken error on alipay_notify
    skip_before_action :verify_authenticity_token

    # success url
    def charge_done
      #alipay, get, "result"=>"success", "out_trade_no"=>"R677576938"
      #upacp_pc, post, "orderId"=>"R677576938", "respMsg"=>"success"
      order = retrieve_order
      # get charge from server, notify message may be delay
      unless order.complete?
        payment_method = order.payments.last.payment_method
        if payment_method.kind_of? Gateway::PingppBase
          charge = payment_method.provider.retrieve_charge( order )
          if charge['paid']
             order.reload
          end
        end
      end
      if order.complete?
        redirect_to spree.order_path( order )
      else
        redirect_to checkout_state_path(order.state)
      end
    end

    def charge_notify
      begin
        event = JSON.parse( request.raw_post )
        response_status, response_body = Gateway::PingppEventHandler.new( event ).perform
      rescue JSON::ParserError
        response_body = 'JSON 解析失败'
      end
      render plain: response_body, status: response_status, content_type: 'text/plain; charset=utf-8'
    end

    def test_charge_notify
      begin
        event = JSON.parse( request.raw_post )
        response_status, response_body = Gateway::PingppEventHandler.new( event ).perform
      rescue JSON::ParserError
        response_body = 'JSON 解析失败'
      end
      render plain: response_body, status: response_status, content_type: 'text/plain; charset=utf-8'
    end


    private

    def retrieve_order()
      order_number = ( params["orderId"] || params["out_trade_no"] )
      # channel alipay_wap cannel_url is charge_done,  order_number maybe nil in that case.
      Spree::Order.find_by_number(order_number) || current_order
    end

  end
end
