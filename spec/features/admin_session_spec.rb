require 'rails_helper'

describe "admin session", :type => :feature do
  before(:each) do
    Spree::Site.current= create(:site1)
    @user = create(:admin_user, :email => "email@person.com", :password => "secret", :password_confirmation => "secret", :site_id=> Spree::Site.current.id)
    visit spree.admin_path
  end

  it "have admin login page" do
    page.current_url.should include('new_admin_session')
    page.should have_selector("form#new_spree_user")
  end

  it "sign admin in" do
    fill_in_user
    click_on "登录"
    page.current_url.should include( 'admin/orders' )
  end

  it "should not sign admin of other site" do
    @user = create(:admin_user, :email => "email2@person.com", :password => "secret", :password_confirmation => "secret", :site_id=>2)
    fill_in_user
    click_on "登录"
    page.current_url.should include( 'new_admin_session' )
  end

  def fill_in_user
    user = "spree_user"
    fill_in "#{user}_email", :with => @user.email
    fill_in "#{user}_password", :with => @user.password
  end

end
