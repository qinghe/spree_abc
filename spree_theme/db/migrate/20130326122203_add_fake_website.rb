class AddFakeWebsite < ActiveRecord::Migration
  def up
    
    #site use theme without native layout, theme_id>0, release_id is in template_theme table
    #site use theme with native layout, release_id>0, template_theme.release_id=0
    if ActiveRecord::Base.connection.table_exists? 'spree_sites'
      add_column :spree_sites, :index_page, :integer, :default => 0
      add_column :spree_sites, :theme_id, :integer, :default => 0
      add_column :spree_sites, :template_release_id, :integer, :default => 0
    else
      # fake website for test only, user would change index_page, should store it.
      create_table :spree_fake_websites do |t|
        t.string :name,:limit => 24,     :null => false
        t.string :domain,:limit => 24
        t.string :short_name,:limit => 24,     :null => false
        t.integer :index_page,     :null => false, :default => 0
        t.integer :theme_id,     :null => false, :default => 0
        t.integer :template_release_id,     :null => false, :default => 0
      end         
    end

  end

  def down
    if ActiveRecord::Base.connection.table_exists? 'spree_sites'
      remove_column :spree_sites, :index_page
      remove_column :spree_sites, :theme_id
      remove_column :spree_sites, :template_release_id
    else
      drop_table :spree_fake_websites
    end
  end
end
