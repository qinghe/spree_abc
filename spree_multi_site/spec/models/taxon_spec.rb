#encoding: utf-8
require 'spec_helper'
describe Spree::Taxon do
  before(:each) do
    @taxonomy = create(:taxonomy)
    @root_taxon = @taxonomy.root
    @child_taxon = create(:taxon, :taxonomy_id => @taxonomy.id, :parent => @root_taxon)
  end

  it "should create taxon with valid site!" do
    new_taxon = Spree::Taxon.create!({ taxonomy_id: 0, name: 'name' })
    new_taxon.site.should eq Spree::Site.current
  end

  it "should copy" do
   #open( File.join Rails.root, 'public','favicon.ico' ) do|f|
   #  taxon.icon = f
   #  taxon.save
   #end
    #Spree::Site.current = Spree::Site.find 3
    #taxon = Spree::Taxon.unscoped.roots.where(:site_id=>2).first
    copied_taxon = @root_taxon.clone_branch
    expect( copied_taxon.self_and_descendants.size ).to eq @root_taxon.self_and_descendants.size
  end
end
