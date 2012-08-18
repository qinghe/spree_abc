# This migration comes from spree_multi_site (originally 20120420205725)
class AddSiteLayout < ActiveRecord::Migration
  def self.up
    add_column :spree_sites, :layout, :string
  end

  def self.down
    remove_column :spree_sites, :layout
  end
end