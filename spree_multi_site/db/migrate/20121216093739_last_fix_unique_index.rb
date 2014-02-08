class LastFixUniqueIndex < ActiveRecord::Migration
  def change
    if Spree::Site.table_exists?
      if defined?(Spree::Auth)
        remove_index "spree_users", :name => "email_idx_unique"      
        add_index "spree_users", ["site_id","email"], :name => "email_idx_unique", :unique => true
      end
            
      remove_index :spree_preferences, :name => 'index_spree_preferences_on_key'
      add_index "spree_preferences", ["site_id","key"], :name => "index_spree_preferences_on_key", :unique => true

      remove_index :spree_products, :name => 'permalink_idx_unique'
      add_index "spree_products", ["site_id", "permalink"], :name => "permalink_idx_unique", :unique => true
    end
  end
end
