require 'spec_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }

  before do
    @gateway = Spree::Gateway::PingppPc.create!({
      name: "PingppPcAlipay",
      active: true,
      preferences: {
        channels: 'alipay_pc_direct',
        app_key: 'app_S8qPKGyH8SKSvfLq',
        api_key: 'sk_test_W9azX94mLu1O4SCibPHCCyHG'
      }
    })
    FactoryGirl.create(:shipping_method)
  end


  it "pays for an order successfully" do

    payment_method_css = "#order_payments_attributes__payment_method_id_#{@gateway.id}"


    visit spree.root_path
    click_link product.name
    click_button 'Add To Cart'
    click_button 'Checkout'

    #within("#guest_checkout") do
    #  fill_in "Email", :with => "test@example.com"
    #  click_button 'Continue'
    #end

    fill_in_billing
    click_button "Save and Continue"
    # Delivery step doesn't require any action
    click_button "Save and Continue"

    choose payment_method_css
    click_button "Save and Continue"
    # should redirect to  pingpp mock page
    find("#btn_pay").click
    #page.should have_content("Your order has been processed successfully")
    #Spree::Payment.last.should be_complete
  end

  def fill_in_billing
    fill_in "order_email", :with => "test@example.com"

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

  def switch_to_paypal_login
    # If you go through a payment once in the sandbox, it remembers your preferred setting.
    # It defaults to the *wrong* setting for the first time, so we need to have this method.
    unless page.has_selector?("#login_email")
      find("#loadLogin").click
    end
  end

end
