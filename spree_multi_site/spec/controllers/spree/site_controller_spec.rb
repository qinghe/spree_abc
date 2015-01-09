require 'spec_helper'

describe Spree::SitesController do

  it "should create site" do  
     site_params = { "site"=>{"name"=>"test", "short_name"=>"test", 
       "users_attributes"=>{"0"=>{"email"=>"test@dalianshops.com", "password"=>"123456", "password_confirmation"=>"123456"}}}
       }  
    spree_post :quick_lunch,site_params    
    site = assigns(:site) 
    site.should be_kind_of Spree::Site
    site.shipping_categories.count.should eq 1
    site.users.count.should eq 1
    response.should redirect_to(site.admin_url)
  end
end
