require "pingpp"
module Spree
  class Gateway::PingppProvider
    PINGPP_NOTIFY_URL = 'https://api.pingxx.com/notify/charges/',
    PINGPP_MOCK_URL = 'http://sissi.pingxx.com/mock.php',
    ALIPAY_PC_DIRECT_URL = 'https://mapi.alipay.com/gateway.do',
    UPACP_PC_URL = 'https://gateway.95516.com/gateway/api/frontTransReq.do'

    PingppChannelEnum = Struct.new( :alipay_pc_direct, :upacp_pc )[ 'alipay_pc_direct', 'upacp_pc']
    attr_accessor :payment_method

    def initialize( payment_method )
      self.payment_method = payment_method
      setup_api_key( payment_method.preferred_api_key )
    end

    def setup_api_key( key )
      Pingpp.api_key = key
    end

    def create_charge( order, channel, success_url )
      channel ||= PingppChannelEnum.alipay_pc_direct
      params = {
        :order_no => order.number,
        :amount   => (order.total * 100).to_i,                     # in cent
        :subject  => "Order : #{order.number}",
        :body     => order.products.collect(&:name).to_s,  #String(400)
        :channel  => channel,
        :currency => "cny",
        :client_ip=> get_client_ip,
        :app => { :id => payment_method.preferred_app_key },
      }
      extra_alipay_params= {
        :extra => {
          # alipay
          :success_url => success_url #
        }
      }
      extra_upacp_params= {
        :extra => {
          # upacp
          :result_url => success_url #
        }
      }

      case channel
      when PingppChannelEnum.alipay_pc_direct
        params.merge! extra_alipay_params
      when PingppChannelEnum.upacp_pc
        params.merge! extra_upacp_params
      end
        charge = Pingpp::Charge.create( params  )
        # store charge "id": "ch_Hm5uTSifDOuTy9iLeLPSurrD",
        payment = get_payment_by_order( order )
        payment.update_attribute( :response_code, charge['id'] )

      charge
    end

    def retrieve_charge
      payment = get_payment_by_order( order )
      charge = Pingpp::Charge.retrieve( payment.response_code )
    end

    def get_payment_url( charge )
      channel = charge['channel'];
      raise "no_such_channel: #{channel}" unless PingppChannelEnum.values.include? channel
      raise "no_credential" unless charge['credential'].present?
      raise "no_valid_channel_credential" unless charge['credential'][channel].present?

      if charge['livemode'] == false
        return test_mode_notify_url(charge);
      end

      credential = charge['credential'][channel];

      if channel == PingppChannelEnum.upacp_pc
        form_submit(cfg.UPACP_PC_URL, 'post', credential);

      elsif channel == PingppChannelEnum.alipay_pc_direct
        credential["_input_charset"] = 'utf-8';
        ALIPAY_PC_DIRECT_URL + "?" + credential.to_param;
      end

    end

    def test_mode_notify_url(charge)
      params = { ch_id: charge['id'], scheme: 'http',  channel: charge['channel']  }

      if charge['order_no']
        params['order_no'] = charge['order_no']
      elsif charge['orderNo']
        params['order_no'] = charge['orderNo']
      end

      if charge['time_expire']
        params['time_expire'] = charge['time_expire']
      elsif charge['timeExpire']
        params['time_expire'] = charge['timeExpire']
      end
      if charge['extra']
        params['extra'] = charge['extra'].to_json
      end
      PINGPP_MOCK_URL+'?'+ params.to_param
    end


    def cancel( order )
      Pingpp::Charge.retrieve("CHARGE_ID").refunds.create(:description => "Refund Description")
    end

    def get_payment_by_order( order )
      order.payments.last
    end

    def get_client_ip
      "127.0.0.1"
    end
  end
end
