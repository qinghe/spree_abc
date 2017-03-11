require 'rails_helper'


describe Spree::Product, type: :model do

  context "#category" do
    let(:taxonomy) { create(:taxonomy, name: I18n.t('spree.taxonomy_categories_name')) }
    let(:product) { create(:product, taxons: [taxonomy.taxons.first]) }

    it 'should build path by Taxon' do
      taxon = product.taxons.first
      path = "/#{taxon.id}-#{taxon.permalink}/#{product.id}-#{product.friendly_id}"
      expect(product.build_path( taxon )).to eql(path)
    end
  end

end
