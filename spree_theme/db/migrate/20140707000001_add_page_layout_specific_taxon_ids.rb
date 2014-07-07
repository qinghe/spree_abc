class AddPageLayoutSpecificTaxonIds < ActiveRecord::Migration
  def change
    # section is specific for assigned taxons, only appear in those pages.
    # comma separated taxon_id
    add_column :spree_page_layouts, :specific_taxon_ids, :string, :default => ''
  end

end
