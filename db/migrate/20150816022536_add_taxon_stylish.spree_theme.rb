# This migration comes from spree_theme (originally 20150815070030)
class AddTaxonStylish < ActiveRecord::Migration
  def change
    # each store have a theme,
    # each taxon belongs to the theme,
    # each theme have several list style, by default it is 0
    # a taxon could select own style.
    add_column :spree_taxons, :stylish, :integer, :null => false, :default => 0
    add_column :spree_page_layouts, :stylish, :integer,:null => false,  :default => 0

  end

end
