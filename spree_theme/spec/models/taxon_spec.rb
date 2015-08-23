require 'spec_helper'
describe Spree::Taxon, :type => :model do
  before do
     @taxonomy = create(:taxonomy)
     @root_taxon = @taxonomy.root
     @child_taxon = create(:taxon, :taxonomy_id => @taxonomy.id, :parent => @root_taxon)
  end

  #it "should copy" do
  # #open( File.join Rails.root, 'public','favicon.ico' ) do|f|
  # #  taxon.icon = f
  # #  taxon.save
  # #end
  #  #Spree::Site.current = Spree::Site.find 3
  #  #taxon = Spree::Taxon.unscoped.roots.where(:site_id=>2).first
  #  copied_taxon = @root_taxon.clone_branch
  #  expect( copied_taxon.self_and_descendants.size ).to eq @root_taxon.self_and_descendants.size
  #end

  #TODO
  # test add_section_piece, section_param should be added
end
