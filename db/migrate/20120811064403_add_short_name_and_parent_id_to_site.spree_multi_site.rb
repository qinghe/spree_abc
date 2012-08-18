# This migration comes from spree_multi_site (originally 20120423194433)
class AddShortNameAndParentIdToSite < ActiveRecord::Migration
  def self.up
    add_column :spree_sites, :parent_id, :integer
    add_column :spree_sites, :short_name, :string
  end

  def self.down
    remove_column :spree_sites, :parent_id
    remove_column :spree_sites, :short_name
  end
end