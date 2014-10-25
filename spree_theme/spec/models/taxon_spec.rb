require 'spec_helper'
describe Spree::Taxon do
  let (:taxon) { Spree::Taxon.roots.first }

  
  it "should copy" do
   #open( File.join Rails.root, 'public','favicon.ico' ) do|f|
   #  taxon.icon = f
   #  taxon.save
   #end 
    #Spree::Site.current = Spree::Site.find 3
    #taxon = Spree::Taxon.unscoped.roots.where(:site_id=>2).first
Rails.logger.debug "..taxon = #{taxon.inspect}"
    copied_taxon = taxon.copy
Rails.logger.debug "..copied taxon = #{copied_taxon.inspect}"
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
