require 'spec_helper'

describe Spree::SitesController do

  it "should create site" do   
    spree_post :quick_lunch,{:site=>{:name=>"a test"}, :user=>{:email=>'test@test.com',:password=>'123456'}}    
    site = assigns(:site) 
    site.should be_kind_of Spree::Site
    site.shipping_categories.count.should eq 1
    site.users.count.should eq 1
    response.should redirect_to(site.admin_url)
  end
end
