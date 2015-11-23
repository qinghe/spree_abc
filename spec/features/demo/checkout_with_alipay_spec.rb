require 'rails_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  before(:all) do
    load  File.join( Rails.root, 'spree_theme', 'db', 'themes','seed.rb')

  end

  let( :alipay_config ) {
    {
      preferred_alipay_pid: ENV['ALIPAY_PID'],
      preferred_alipay_key: ENV['ALIPAY_KEY'],
      name: "Alipay",
      active: true,
      environment: Rails.env
    }
  }

  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }

  before do
    raise "plese set ALIPAY_KEY, ALIPAY_PID" unless  ENV['ALIPAY_PID'] && ENV['ALIPAY_KEY']
    FactoryGirl.create(:shipping_method)
  end

  context "alipay_escrow" do
    before do
      @gateway = Spree::Gateway::AlipayEscrow.create!( alipay_config )
    end
    it "pay an order successfully" do
      #order[payments_attributes][][payment_method_id]
      #order_payments_attributes__payment_method_id_1
      payment_method_css = "order_payments_attributes__payment_method_id_#{@gateway.id}"

      add_to_cart
    end
  end

end
