# This migration comes from spree_theme (originally 20140707000001)
class AddSpecificTaxonIds < ActiveRecord::Migration
  def change
    add_column :spree_template_themes, :specific_taxon_ids, :string, :default => ''
  end
end

