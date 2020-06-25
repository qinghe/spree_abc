# This migration comes from spree_omniauth (originally 20151229135000)
class CreateOauths < ActiveRecord::Migration
  def self.up
    create_table :spree_oauth_accounts do |t|
      t.string :provider, :nil => false
      t.integer :uid, :nil => false
      t.text :info
      t.string :name
      t.integer :user_id, null: false
      t.timestamps null: false
    end
    add_index :spree_oauth_accounts, [:uid,:provider], :unique => true
    add_index :spree_oauth_accounts, :user_id
  end

  def self.down
    drop_table :spree_oauth_accounts
  end
end
