# This migration comes from spree_theme (originally 20140827070030)
class AddTaxonReplacedBy < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :replaced_by, :integer, :null => false, :default => 0
  end

end
