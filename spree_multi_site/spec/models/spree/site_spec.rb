require 'spec_helper'

describe Spree::Site do
  before(:each) do
    @site = Spree::Site.new(:name=>'ABC',:domain=>'www.abc.net',:short_name=>'shop')
  end

  it "should be valid" do
    @site.should be_valid
  end
  it "should not be valid" do
    @site.short_name = nil
    @site.valid?.should be_false
  end
    
  it "should create site and user" do
    user_attributes = {"email"=>"test@abc.com", "password"=>"a12345z", "password_confirmation"=>"a12345z"}
    @site.users<< Spree::User.new(user_attributes)
    @site.save
    @site.should_not be_new_record
    @site.users.first.email.should eq(user_attributes['email'])
  end
  
  it "shold load samples" do
    @site.save!
    @site.load_sample
  end
  
  it "should has associations" do
    @site.users.build.should 
    @site.products.build.should
    @site.zones.build.should
    
  end  
  
  it "shold remove samples" do
    
    @site.save!
    @site.load_sample(false)
    Spree::Site.current = @site
    Spree::Product.count.should eq(0)
    Spree::Variant.count.should eq(0)
    Spree::Zone.count.should eq(0)
    Spree::ZoneMember.count.should eq(0)
    Spree::StateChange.count.should eq(0)
    #product variants
    #taxonomy, taxon
    #zone,zone_member
    #state_changes
  end
  
  it "shold create two site and load samples for them" do
    @site1 = Spree::Site.create(:name=>'Site1',:domain=>'www.site1.net',:short_name=>'site1')
    @site2 = Spree::Site.create(:name=>'Site1',:domain=>'www.site1.net',:short_name=>'site2')
    @site1.load_sample
    @site2.load_sample
    #product image copied and in right folder.
  end
  
end
