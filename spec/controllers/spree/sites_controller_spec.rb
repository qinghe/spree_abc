require 'spec_helper'

describe Spree::SitesController do
  let!(:user) { mock_model(Spree::User, :spree_api_key => 'fake', :last_incomplete_spree_order => nil) }
  let(:role) { create(:role) }

  before do
    #request.stub(:host => Spree::Site.first.subdomain)
    Spree::Site.current = Spree::Site.first
    controller.stub(:spree_current_user => user)
  end
  #Delete this example and add some real ones
  it "should use Spree::SitesController" do
    controller.should be_an_instance_of(Spree::SitesController)
  end
#{"utf8"=>"✓", "authenticity_token"=>"Klllros8vRbKw1rGMzq33yHRXJ2ioTyaXV0Uy2YlsUw=", "site"=>{"name"=>"test", "short_name"=>"test", "has_sample"=>"1"}, "user"=>{"email"=>"test@gmail.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "commit"=>"创建"}
  it "should create a site successfully" do
    request.stub(:fullpath => '/new_site')
    spree_post :create, { "site"=>{"name"=>"test", "short_name"=>"test", "admin_email"=>"test@gmail.com", "admin_password"=>"123456", "admin_password_confirmation"=>"123456"} }
    expect(assigns(:site)).to be_kind_of Spree::Site
    expect(response).to redirect_to(spree.site_path(assigns(:site)))
  end

  it "should quick lunch a site successfully" do
    request.stub(:fullpath => '/new_site')
    spree_post :quick_lunch, { "site"=>{"name"=>"test", "short_name"=>"test", "admin_email"=>"test@gmail.com", "admin_password"=>"123456"}}
    expect(assigns(:site)).to be_kind_of Spree::Site
    expect(response).to redirect_to(spree.site_path(assigns(:site)))
  end

  
end
