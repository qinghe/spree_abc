class AddTaxonHref < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :href, :string
  end

end
