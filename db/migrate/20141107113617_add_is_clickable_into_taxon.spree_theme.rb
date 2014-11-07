# This migration comes from spree_theme (originally 20141106070030)
# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class AddIsClickableIntoTaxon < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :is_clickable, :boolean, :null => false, :default => true    
  end
end
