# This migration comes from spree_multi_site (originally 20120416194035)
class AddSiteProducts < ActiveRecord::Migration
  def self.up
    table_name = Spree::Product.connection.table_exists?(:products) ? :products : :spree_products
    add_column table_name, :site_id, :integer
  end

  def self.down
    remove_column Spree::Product.table_name, :site_id
  end
end