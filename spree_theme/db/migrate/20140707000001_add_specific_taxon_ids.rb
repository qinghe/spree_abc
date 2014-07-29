class AddSpecificTaxonIds < ActiveRecord::Migration
  def change
    add_column :spree_template_themes, :specific_taxon_ids, :string, :default => ''
  end
end

