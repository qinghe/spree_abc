# This migration comes from spree_auth (originally 20141002154641)
class AddTooltipsToTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :tooltips, :string
  end
end
