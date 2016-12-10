require 'rails_helper'

describe "home page", :type => :request do
#  let!(:user) { mock_model(Spree::User, :spree_api_key => 'fake', :last_incomplete_spree_order => nil) }
  let(:tld) { Spree::Site.system_top_domain }

  # uses routes test instead
  #it "should go dalianshops.com" do
  #  host! "first.#{tld}"
  #  get '/'
  #  Spree::Site.current.dalianshops?.should be_true
  #end

  #it "should go design.dalianshops.com" do
  #  host! "design.#{tld}"
  #  get '/'
  #  Spree::Site.current.design?.should be_true
  #end

  #it "should go demo.dalianshops.com" do
  #  host! "demo.#{tld}"
  #  get '/'
  #  Spree::Site.current.short_name.should eq 'demo'
  #end

  #it "should go nonexists.dalianshops.com" do
  #  host! "nonexists.#{tld}"
  #  get '/'
  #  expect(page.current_url).to include "under_construction"
  #end
end
