require 'rails_helper'


describe Spree::Post, type: :model do

  context "#category" do
    let(:taxonomy) { create(:taxonomy, name: I18n.t('spree.taxonomy_categories_name')) }
    let(:post) { create(:post, taxons: [taxonomy.taxons.first]) }

    it 'should build path by Taxon' do
      taxon = post.taxons.first
      path = "/post/#{taxon.id}-#{taxon.permalink}/#{post.id}-#{post.friendly_id}"
      expect(post.build_path( taxon )).to eql(path)
    end
  end

end
