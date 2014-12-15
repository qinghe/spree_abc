class AddTaxonReplacedBy < ActiveRecord::Migration
  def change
    # show replaced_by page after it click
    add_column :spree_taxons, :replaced_by, :integer, :null => false, :default => 0
  end

end
