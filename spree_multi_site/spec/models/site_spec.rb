#encoding: utf-8
require 'spec_helper'
describe Spree::Site do
  before(:each) do
    @site = Spree::Site.new(:name=>'ABCD',:domain=>'www.abc.net')
  end

  it "should be valid" do
    @site.should be_valid
    @site.domain = ''
    @site.should be_valid
  
    @site.domain = nil
    @site.should be_valid
    
    @site.domain = 'www.abc.net'
    @site.save!
    
    site2 = @site.dup
    site2.should be_invalid
    site2.short_name = nil
    site2.domain = nil
    site2.should be_valid
    site2.save.should be_true
    site2.short_name.should start_with( @site.short_name)
    site2.short_name.should_not == @site.short_name
  end
  
  
  
  it "should not be valid" do
    @site.name = 'ABC'
    @site.short_name = nil
    @site.valid?.should be_false
    
    @site.name = '大连&白酒!'
    @site.short_name = nil
    @site.valid?.should be_true
    @site.short_name.should eq "da-lian-and-bai-jiu"
    @site.save.should be_true
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
    @site.shipping_categories.should be_present
  end
  
  it "should has associations" do
    @site.users.build.should be_present
    @site.products.build.should be_present
    @site.zones.build.should be_present
    
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
    @site1 = Spree::Site.create!(:name=>'Site1',:domain=>'www.site1.net',:short_name=>'site1')
    @site2 = Spree::Site.create!(:name=>'Site1',:domain=>'www.site2.net',:short_name=>'site2')
    @site1.load_sample
    @site2.load_sample
    #product image copied and in right folder.
  end
  
end
