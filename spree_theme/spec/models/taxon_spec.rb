require 'spec_helper'
describe Spree::Taxon, :type => :model do
  before do
     @taxonomy = create(:taxonomy)
     @root_taxon = @taxonomy.root
     @child_taxon = create(:taxon, :taxonomy_id => @taxonomy.id, :parent => @root_taxon)
  end

  #TODO
  # test add_section_piece, section_param should be added
end
