# This migration comes from spree_multi_site (originally 20141027010101)
class AddProductsGlobalTaxons < ActiveRecord::Migration
  # we want to display product in s.dalianshops.com
  # each product should have global taxon( taxon in dalianshops )  
  create_table :spree_products_global_taxons, :id => false do |t|
    t.references :product
    t.references :taxon
  end

  add_index :spree_products_global_taxons, [:product_id], :name => 'index_spree_products_global_taxons_on_product_id'
  add_index :spree_products_global_taxons, [:taxon_id],   :name => 'index_spree_products_global_taxons_on_taxon_id'
end