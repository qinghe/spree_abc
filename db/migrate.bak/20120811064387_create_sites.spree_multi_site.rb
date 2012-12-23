# This migration comes from spree_multi_site (originally 20120415215214)
class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :spree_sites do |t|
      t.string :name
      t.string :domain

      t.timestamps
    end
  end

  def self.down
    drop_table :spree_sites
  end
end
