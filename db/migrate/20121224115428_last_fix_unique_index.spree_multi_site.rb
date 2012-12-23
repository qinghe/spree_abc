# This migration comes from spree_multi_site (originally 20121216093739)
class LastFixUniqueIndex < ActiveRecord::Migration
  def change
    if Spree::Site.table_exists?
      
      remove_index "spree_users", :name => "email_idx_unique"
      add_index "spree_users", ["site_id","email"], :name => "email_idx_unique", :unique => true

      remove_index :spree_preferences, :name => 'index_spree_preferences_on_key'
      add_index "spree_preferences", ["site_id","key"], :name => "index_spree_preferences_on_key", :unique => true

    end
  end

end
