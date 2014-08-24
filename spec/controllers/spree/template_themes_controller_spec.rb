require 'spec_helper'

describe Spree::TemplateThemesController do
  let!(:user) { mock_model(Spree::User, :spree_api_key => 'fake', :last_incomplete_spree_order => nil) }
  let(:role) { create(:role) }

  before do
    Spree::Site.stub(:current => Spree::Site.first)
    controller.stub(:spree_current_user => user)
    SpreeMultiSite::Config.seed_dir= File.join(SpreeAbc::Application.root,'db') 
  end

  it "should go dalianshops.com" do
    spree_post :page, { "d"=>"www.dalianshops.com" }
    response.should be_success
    Spree::Site.current.dalianshops?.should be_truely
  end

  it "should go design.dalianshops.com" do
    spree_post :page, { "d"=>"design.dalianshops.com" }
    response.should be_success
    Spree::Site.current.design?.should be_truely
    
  end

  it "should go demo.dalianshops.com" do
    spree_post :page, { "d"=>"demo.dalianshops.com" }
    response.should be_success
    Spree::Site.current.short_name.should eq 'demo'
  end

  it "should go nonexists.dalianshops.com" do
    spree_post :page, { "d"=>"www.dalianshops.com" }
    Spree::Site.current.dalianshops?.should be_truely    
  end
end
