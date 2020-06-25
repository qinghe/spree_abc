require "pingpp"
module Spree
  class Gateway::PingppProvider
    include Gateway::PingppHelper
    #PINGPP_NOTIFY_URL = 'https://api.pingxx.com/notify/charges/',
    #PINGPP_MOCK_URL = 'http://sissi.pingxx.com/mock.php',
    #ALIPAY_PC_DIRECT_URL = 'https://mapi.alipay.com/gateway.do',
    #UPACP_PC_URL = 'https://gateway.95516.com/gateway/api/frontTransReq.do'

    PingppPcChannelEnum = Struct.new( :alipay_pc_direct, :upacp_pc )[ 'alipay_pc_direct', 'upacp_pc' ]
    PingppWapChannelEnum = Struct.new(  :alipay_wap, :upacp_wap )[ 'alipay_wap', 'upacp_wap']
    attr_accessor :payment_method

    def initialize( payment_method )
      self.payment_method = payment_method
      setup_api_key( payment_method.preferred_api_key )
    end

    def setup_api_key( key )
      Pingpp.api_key = key
    end

    def create_charge( order, channel, success_url )
      channel ||= PingppPcChannelEnum.alipay_pc_direct
      product_names = order.products.pluck(:name)

      params = {
        :order_no => order.number,
        :amount   => (order.total * 100).to_i,               # in cent
        :subject  => product_names.join(',').truncate(128),
        :body     => product_names.join(',').truncate(500),  #String(400)
        :channel  => channel,
        :currency => "cny",
        :client_ip=> order.last_ip_address,
        :app => { :id => payment_method.preferred_app_key },
      }
      extra_alipay_params= {
        :extra => {
          # alipay
          :success_url => success_url #
        }
      }
      extra_alipay_wap_params= {
        :extra => {
          # alipay
          :cancel_url => success_url,
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
      when PingppPcChannelEnum.alipay_pc_direct
        params.merge! extra_alipay_params
      when PingppPcChannelEnum.upacp_pc
        params.merge! extra_upacp_params
      when PingppWapChannelEnum.alipay_wap
        params.merge! extra_alipay_wap_params
      when PingppWapChannelEnum.upacp_wap
        params.merge! extra_upacp_params
      end
        charge = Pingpp::Charge.create( params  )
        # store charge "id": "ch_Hm5uTSifDOuTy9iLeLPSurrD",
        payment = get_payment_by_order( order )
        payment.update_attribute( :response_code, charge['id'] )

      charge
    end

    def retrieve_charge( order )
      payment = get_payment_by_order( order )
      charge = Pingpp::Charge.retrieve( payment.response_code )
    end

    #def get_payment_url( charge )
    #  channel = charge['channel'];
    #  raise "no_such_channel: #{channel}" unless PingppPcChannelEnum.values.include? channel
    #  raise "no_credential" unless charge['credential'].present?
    #  raise "no_valid_channel_credential" unless charge['credential'][channel].present?
    #  if charge['livemode'] == false
    #    return test_mode_notify_url(charge);
    #  end
    #  credential = charge['credential'][channel];
    #  if channel == PingppPcChannelEnum.upacp_pc
    #    form_submit(cfg.UPACP_PC_URL, 'post', credential);
    #  elsif channel == PingppPcChannelEnum.alipay_pc_direct
    #    credential["_input_charset"] = 'utf-8';
    #    ALIPAY_PC_DIRECT_URL + "?" + credential.to_param;
    #  end
    #end

    #def test_mode_notify_url(charge)
    #  params = { ch_id: charge['id'], scheme: 'http',  channel: charge['channel']  }
    #  if charge['order_no']
    #    params['order_no'] = charge['order_no']
    #  elsif charge['orderNo']
    #    params['order_no'] = charge['orderNo']
    #  end
    #  if charge['time_expire']
    #    params['time_expire'] = charge['time_expire']
    #  elsif charge['timeExpire']
    #    params['time_expire'] = charge['timeExpire']
    #  end
    #  if charge['extra']
    #    params['extra'] = charge['extra'].to_json
    #  end
    #  PINGPP_MOCK_URL+'?'+ params.to_param
    #end


    def cancel( order )
      Pingpp::Charge.retrieve("CHARGE_ID").refunds.create(:description => "Refund Description")
    end

    # * description - before order transition to: :complete
    # *   call spree/payment#gateway_action
    # * params
    #   * options - gateway_options
    # * return - pingpp_response
    def purchase(money, credit_card, options = {})
      # since pingpp is offsite payment, this method is placehodler only.
      # in this way, we could go through spree payment process.
      return Gateway::PingppResponse.new
    end

  end
end
