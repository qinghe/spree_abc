# This migration comes from spree_multi_site (originally 20120420163828)
class AddSiteOrders < ActiveRecord::Migration
  def self.up
    table_name = Spree::Order.connection.table_exists?(:orders) ? :orders : :spree_orders
    add_column table_name, :site_id, :integer
  end

  def self.down
    remove_column Spree::Order.table_name, :site_id
  end
end