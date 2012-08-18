# This migration comes from spree_multi_site (originally 20120416160045)
class AddSiteTaxonomies < ActiveRecord::Migration
  def self.up
    #for history reason, 
    #spree's table have no prefix 'spree_' at beginning,
    #later migration NamespaceTopLevelModels add prefix 'spree_'
    #so here table_exists?(:taxonomies) is accurate name.
    table_name = Spree::Taxonomy.connection.table_exists?(:taxonomies) ? :taxonomies : :spree_taxonomies
    add_column table_name, :site_id, :integer
  end

  def self.down
    remove_column Spree::Taxonomy.table_name, :site_id
  end
end