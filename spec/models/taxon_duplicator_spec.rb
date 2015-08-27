#encoding: utf-8
require 'rails_helper'
describe Spree::Taxon do
  let(:image) { File.open(File.expand_path('../../fixtures/qinghe.jpg', __FILE__)) }

  before(:each) do
    Spree::Site.current = create(:site_demo)
    @root_taxon = create(:taxon_for_duplicator)
    # root with 3 childen
    @taxonomy = @root_taxon.taxonomy
  end

  context 'taxon with icon' do
    before(:each) do
      @root_taxon.update_attribute(:icon, image)
    end
    after(:each) do
      @root_taxon.update_attribute(:icon, nil)
    end

    it "should duplicate taxon " do
      expect{ @root_taxon.custom_duplicate.save!}.to change{Spree::Taxon.count}.by(1)
    end

    it "should duplicate taxon with icon" do
      copied_taxon = @root_taxon.custom_duplicate
      copied_taxon.save!
      copied_taxon.reload
      File.should exist(copied_taxon.icon.path )
    end

    context "current site is demo2" do
      let( :copied_taxon ){ taxon = @root_taxon.clone_branch; taxon.save!;taxon }

      before(:each) do
        Spree::Site.current = create(:site_demo2)
      end

      it "should copy taxonomy to current site" do
        expect{copied_taxon}.to change{Spree::Taxon.count}.by(4)
      end

      it "should clone branch with icon" do
        #puts "@root_taxon =#{@root_taxon.id} ,copied_taxon=#{copied_taxon.id}"
        File.should exist(copied_taxon.icon.path )
      end
    end

  end

  it "should create taxon with valid site!" do
    new_taxon = Spree::Taxon.create!({ taxonomy_id: 0, name: 'name' })
    new_taxon.site.should eq Spree::Site.current
  end


  it "should clone taxons " do
    expect{@root_taxon.clone_branch.save!}.to change{Spree::Taxon.count}.by(4)
  end

  it "should clone taxonomy " do
    expect{@root_taxon.clone_branch.save!}.to change{Spree::Taxonomy.count}.by(1)
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
