# This migration comes from spree_multi_site (originally 20120804054331)
class AddSiteUsers < ActiveRecord::Migration
  def up
    table_name = Spree::User.connection.table_exists?(:users) ? :users : :spree_users
    add_column table_name, :site_id, :integer
  end

  def down
    remove_column Spree::User.table_name, :site_id, :integer
  end
end
