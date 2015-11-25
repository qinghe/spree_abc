require 'rails_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  before(:all) do
    raise "plese set ALIPAY_KEY, ALIPAY_PID" unless  ENV['ALIPAY_PID'] && ENV['ALIPAY_KEY']
    FactoryGirl.create(:shipping_method)

    Spree::Site.current = create(:site1)
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
      environment: Rails.env
    }
  }

  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }

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

  def fill_in_billing

    within("#billing") do
      fill_in "First Name", :with => "Test"
      fill_in "Last Name", :with => "User"
      fill_in "Street Address", :with => "1 User Lane"
      # City, State and ZIP must all match for PayPal to be happy
      fill_in "City", :with => "Adamsville"
      select "United States of America", :from => "order_bill_address_attributes_country_id"
      select "Alabama", :from => "order_bill_address_attributes_state_id"
      fill_in "Zip", :with => "35005"
      fill_in "Phone", :with => "555-AME-RICA"
    end
  end

  def add_to_cart

    visit spree.products_path

    click_link product.name
    find('#add-to-cart-button').click #click_button
    click_button 'Checkout'

    # spree_auth_devise requried
    within("#guest_checkout") do
      fill_in "Email", :with => "test@example.com"
      click_button 'Continue'
    end
  end

end
