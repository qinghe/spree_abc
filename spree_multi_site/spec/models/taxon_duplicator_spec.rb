#encoding: utf-8
require 'spec_helper'
describe Spree::Taxon do
  let(:site) { create(:site_demo) }
  let(:image) { File.open(File.expand_path('../../fixtures/qinghe.jpg', __FILE__)) }

  before(:each) do
    Spree::Site.current = site
    @taxonomy = create(:taxonomy)
    @root_taxon = @taxonomy.root
    @child_taxon = create(:taxon, :taxonomy_id => @taxonomy.id, :parent => @root_taxon, :icon => image)
  end

  it "should duplicate taxon with icon" do
    duplicated_taxon = @child_taxon.duplicate
    duplicated_taxon.parent = @root_taxon
    duplicated_taxon.save!
    duplicated_taxon.reload
    File.should exist(duplicated_taxon.icon.path )

  end

  it "should create taxon with valid site!" do
    new_taxon = Spree::Taxon.create!({ taxonomy_id: 0, name: 'name' })
    new_taxon.site.should eq Spree::Site.current
  end

  context "current site is demo2" do
    before(:each) do
      @original_tree = @root_taxon.self_and_descendants
      Spree::Site.current = create(:site_demo2)
    end
    it "should copy taxonomy to current site" do

      copied_taxon = @root_taxon.clone_branch
      copied_taxon.save!
      copied_tree = copied_taxon.self_and_descendants

      expect( copied_tree.size ).to eq @original_tree.size
    end
  end
#  it "should copy with icon" do
#    Spree::Site.current = Spree::Site.find 2
#    taxon = Spree::Taxon.roots.first
#    open( File.join Rails.root, 'app','assets', 'images','rails.png' ) do|f|
#      taxon.icon = f
#      taxon.save!
#    end
#    File.should exist(taxon.icon.path)
#    #have to reload it
#    taxon =  Spree::Taxon.find( taxon.id )

#    Spree::Site.current = Spree::Site.find 1
#    new_taxon = Spree::Taxon.find_or_copy taxon
#    Rails.logger.debug "just after find_or_copy............."
#    new_taxon.reload
#    new_taxon.should be_persisted
#    new_taxon.site.should eq Spree::Site.current
#    new_taxon.taxonomy.should be_present
#    new_taxon.descendants.size.should eq taxon.descendants.size

#    File.should exist(new_taxon.icon.path )
#    Rails.logger.debug "before taxon reload........."
#    taxon.reload

#    Rails.logger.debug " taxon.icon=#{taxon.icon.path}"
#    Rails.logger.debug " new_taxon.icon=#{new_taxon.icon.path}"
#    File.should exist(taxon.icon.path )
#
#  end


end
