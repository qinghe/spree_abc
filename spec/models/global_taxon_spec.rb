require 'rails_helper'
describe Spree::Taxon do
  let(:site1){ create(:site1)}
  let(:site2){ create(:site2)}
  before(:each) do
    Spree::Site.with_site( site1) do
       @taxon_of_site1 = create(:taxon, :name => "Taxon of site1")
    end
    Spree::Site.with_site( site2) do
       @product_of_site2 =  create(:product, :theme_id=>1)
    end
  end
  #let(:variant_of_site2) { create(:variant, :product => product_of_site2) }

  it "should assign global taxon" do

    Spree::Site.current = site2

    Spree::MultiSiteSystem.with_context_free_taxon {
      @product_of_site2.global_taxons.count.should eq 0
      @product_of_site2.update_attribute(:global_taxon_ids,[@taxon_of_site1.id])
      @product_of_site2.global_taxons.count.should eq 1
    }

  end


  it "should get theme products" do
    #Spree::Site.current = Spree::Site.first
    #products = Spree::MultiSiteSystem.with_context_site1_themes{
    #            searcher = Spree::Config.searcher_class.new({})
    #            searcher.retrieve_products.where('spree_products.theme_id>0')
    #}
    ##get themes products from design shop
    #expect(products).to be_present
  end

  #TODO
  # test add_section_piece, section_param should be added
end
