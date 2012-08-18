# This migration comes from spree_multi_site (originally 20120813135747)
class AddSiteTaxons < ActiveRecord::Migration
  def up
    table_name = Spree::Taxon.connection.table_exists?(:taxons) ? :taxons : :spree_taxons
    add_column table_name, :site_id, :integer
  end

  def down
    remove_column Spree::Taxon.table_name, :site_id, :integer
  end

end
