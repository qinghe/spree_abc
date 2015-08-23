require 'rails_helper'
describe Spree::Taxon do

  it "should copy" do
    Spree::Site.current = Spree::Site.find 2

    taxon = Spree::Taxon.roots.first
    open( File.join Rails.root, 'app','assets', 'images','rails.png' ) do|f|
      taxon.icon = f
      taxon.save!
    end
    File.should exist(taxon.icon.path)
    #have to reload it
    taxon =  Spree::Taxon.find( taxon.id )

    Spree::Site.current = Spree::Site.find 1
    new_taxon = Spree::Taxon.find_or_copy taxon
    Rails.logger.debug "just after find_or_copy............."
    new_taxon.reload
    new_taxon.should be_persisted
    new_taxon.site.should eq Spree::Site.current
    new_taxon.taxonomy.should be_present
    new_taxon.descendants.size.should eq taxon.descendants.size

    File.should exist(new_taxon.icon.path )
    Rails.logger.debug "before taxon reload........."
    taxon.reload

    Rails.logger.debug " taxon.icon=#{taxon.icon.path}"
    Rails.logger.debug " new_taxon.icon=#{new_taxon.icon.path}"
    File.should exist(taxon.icon.path )

  end

  #TODO
  # test add_section_piece, section_param should be added
end
