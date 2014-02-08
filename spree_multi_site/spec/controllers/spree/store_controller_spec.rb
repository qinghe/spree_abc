require 'spec_helper'

describe Spree::StoreController do

  #Delete this example and add some real ones
  it "should use Spree::StoreController" do
    expect( Spree::StoreController.ancestors).to include(Spree::MultiSiteSystem)    
    controller.should be_an_instance_of(Spree::StoreController)
    expect( controller.methods).to include(:get_site_and_products)
    
  end
#{"utf8"=>"✓", "authenticity_token"=>"Klllros8vRbKw1rGMzq33yHRXJ2ioTyaXV0Uy2YlsUw=", "site"=>{"name"=>"test", "short_name"=>"test", "has_sample"=>"1"}, "user"=>{"email"=>"test@gmail.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "commit"=>"创建"}
  it "should create a site" do

  end
end
