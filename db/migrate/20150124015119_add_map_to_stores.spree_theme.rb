# This migration comes from spree_theme (originally 20150124000001)
# This migration comes from spree_auth (originally 20141002154641)
class AddMapToStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :map_lat, :string, :length=>10
    add_column :spree_stores, :map_lng, :string, :length=>10
    add_column :spree_stores, :map_title, :string
    add_column :spree_stores, :map_content, :string
    
  end
end
