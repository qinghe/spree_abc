# This migration comes from spree_multi_site (originally 20120425030746)
class AddLftRgtToSite < ActiveRecord::Migration
  def self.up
    add_column :spree_sites, :rgt, :integer
    add_column :spree_sites, :lft, :integer
  end

  def self.down
    remove_column :spree_sites, :lft
    remove_column :spree_sites, :rgt
  end
end