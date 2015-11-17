#inspired by https://github.com/spree-contrib/spree_skrill
module Spree
  class PingppStatusController < StoreController
    #fixes Action::Controller::InvalidAuthenticityToken error on alipay_notify
    skip_before_action :verify_authenticity_token

    # success url
    def charge_done
      #alipay, get, "result"=>"success", "out_trade_no"=>"R677576938"
      #upacp_pc, post, "orderId"=>"R677576938", "respMsg"=>"success"
      order = retrieve_order
      if order.complete?
        spree.order_path( order )
      else
        redirect_to checkout_state_path(@order.state)
      end
    end

    def charge_notify
      begin
        event = JSON.parse( request.body )
        response_status, response_body = PingppEventHandler.new( event ).perform
      rescue JSON::ParserError
        response_body = 'JSON 解析失败'
      end
      render plain: response_body, status: response_status, content_type: 'text/plain; charset=utf-8'
    end

    private

    def retrieve_order()
      order_number = ( params["orderId"] || params["out_trade_no"] )
      @order = Spree::Order.find_by_number!(order_number)
    end


  end
end
