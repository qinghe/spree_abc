require 'rails_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  before(:all) do
    raise "plese set ALIPAY_KEY, ALIPAY_PID" unless  ENV['ALIPAY_PID'] && ENV['ALIPAY_KEY']
    Spree::Site.current = create(:site1)
    FactoryGirl.create(:shipping_method)
    load  File.join( Rails.root, 'spree_theme', 'db', 'themes','seed.rb')
    # for unkonwn reason, is_public is false, we set it here
    Spree::Store.current.update_attributes( theme_id: Spree::TemplateTheme.first.id, is_public: true )
  end

  let( :alipay_config ) {
    {
      preferred_alipay_pid: ENV['ALIPAY_PID'],
      preferred_alipay_key: ENV['ALIPAY_KEY'],
      name: "Alipay",
      active: true,
      user_terminal: Spree::UserTerminal.first,
      environment: Rails.env
    }
  }

  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }

  context "alipay_escrow" do
    before do
      @gateway = Spree::Gateway::AlipayEscrow.create!( alipay_config )
    end
    it "pay an order successfully" do
      shipping_method = Spree::ShippingMethod.first
      #Rails.logger.debug " shipping_method = #{shipping_method.inspect}"
      #Rails.logger.debug " zone = #{Spree::Zone.first.inspect}"
      #order[payments_attributes][][payment_method_id]
      #order_payments_attributes__payment_method_id_1
      payment_method_css = "order_payments_attributes__payment_method_id_#{@gateway.id}"

      add_to_cart

      fill_in_address
      fill_in_delivery
      fill_in_payment

      alipay_window = window_opened_by do
        click_button '支付'
      end

      within_window alipay_window do
        expect(page).to have_content( product.price.to_s )
      end
    end
  end

  def fill_in_address

    within("#checkout_form_address") do
      #  order_bill_address_attributes_country_id
      select "中国", :from => "order_bill_address_attributes_country_id" # china
      select "辽宁", :from => "order_bill_address_attributes_state_id"   # liaoning
      select "大连", :from => "order_bill_address_attributes_city_id" # city
      fill_in "姓名", :with => "Test" #name
      fill_in "详细地址", :with => "xi'an road 6#, 1120room"
      fill_in "邮编", :with => "116000"       #postal code
      fill_in "电话", :with => "13888888888" #phone
      click_button '保存并继续'
    end
  end

  def fill_in_delivery
    within("#checkout_form_delivery") do
      click_button '保存并继续'
    end
  end

  def fill_in_payment
    within("#checkout_form_payment") do
      choose @gateway.name
    end
  end

  def add_to_cart

    visit spree.products_path

    click_link product.name
    find('button#add-to-cart-button').click #click_button
    find('button#checkout-link').click
    click_link '创建一个新帐号' #make a new account

    expect(page).to have_xpath("//form[@id='new_spree_user']")

    # spree_auth_devise requried
    within("#new_spree_user") do
      find('#spree_user_email').set('test@example.com')
      find('#spree_user_password').set('spree123')
      find('#spree_user_password_confirmation').set('spree123')
      click_button '创建' #create
    end
  end

end
