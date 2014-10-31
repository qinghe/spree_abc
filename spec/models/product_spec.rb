require 'spec_helper'
describe Spree::Product do
  
  it "should assign global taxon" do
    taxon_from_site1 = nil
    Spree::Site.with_site(Spree::Site.first){
      taxon_from_site1 = Spree::Taxon.first
    }
    
    taxon_from_site1.should be_present
    
    Spree::Site.current = Spree::Site.find 2
    
    product_from_site2 = Spree::Product.first
    product_from_site2.should be_present
    
    
    
    Spree::MultiSiteSystem.with_context_admin_site_product {
      product_from_site2.global_taxons.count.should eq 0      
      product_from_site2.update_attribute(:global_taxon_ids,[taxon_from_site1.id])
      product_from_site2.global_taxons.count.should eq 1
    }
             
  end
  
  
  it "should get theme products" do
    products = Spree::MultiSiteSystem.with_context_site1_themes{
                searcher = Spree::Config.searcher_class.new({})
                searcher.retrieve_products.where('spree_products.theme_id>0')                
    }
    
    products.should be_a_kind_of Array
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
