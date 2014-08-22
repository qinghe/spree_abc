# This migration comes from spree_theme (originally 20140822070030)
class AddTaxonHref < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :href, :string
  end

end
