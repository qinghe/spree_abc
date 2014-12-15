require 'spec_helper'

describe "home page", :type => :request do
#  let!(:user) { mock_model(Spree::User, :spree_api_key => 'fake', :last_incomplete_spree_order => nil) }
#  let(:role) { create(:role) }

#  before do
#    Spree::Site.stub(:current => Spree::Site.first)
#    controller.stub(:spree_current_user => user)
#    SpreeMultiSite::Config.seed_dir= File.join(SpreeAbc::Application.root,'db') 
#  end

  it "should go dalianshops.com" do
    get '/', { "n"=>"firstshop.dalianshops.com" }
    Spree::Site.current.dalianshops?.should be_true
  end

  it "should go design.dalianshops.com" do
    get '/', { "n"=>"design.dalianshops.com" }
    Spree::Site.current.design?.should be_true
    
  end

  it "should go demo.dalianshops.com" do
    get '/', { "n"=>"demo.dalianshops.com" }
    Spree::Site.current.short_name.should eq 'demo'
  end

  it "should go nonexists.dalianshops.com" do
    get '/', { "n"=>"nonexists.dalianshops.com" }
    Spree::Site.current.dalianshops?.should be_true
  end
end
