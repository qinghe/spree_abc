#encoding: utf-8
require 'spec_helper'
describe Spree::Taxon do
  before(:each) do
    Spree::Site.current = Spree::Site.create!(:name=>'ABCD',:domain=>'www.abc.net')
    @taxon = Spree::Taxon.new(:name=>'ABCD')
  end
  it "should create taxon with valid site!" do
    new_taxon = Spree::Taxon.create!({ taxonomy_id: 0, name: 'name' }) 
    new_taxon.site.should eq Spree::Site.current
  end  
end
