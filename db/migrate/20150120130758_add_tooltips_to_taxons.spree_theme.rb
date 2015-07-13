# This migration comes from spree_theme (originally 20150120074452)
class AddTooltipsToTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :tooltips, :string
  end
end
