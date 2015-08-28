# This migration comes from spree_comments (originally 20141202082639)
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :spree_comments do |t|
      t.string :title, :limit => 50, :default => "" 
      t.text :comment 
      t.references :commentable, :polymorphic => true
      t.references :user
      t.string :email, :limit => 50, :default => "" 
      t.string :cellphone, :limit => 50, :default => "" 
      t.integer :comment_type_id
      t.timestamps
    end

    add_index :spree_comments, :commentable_type
    add_index :spree_comments, :commentable_id
    add_index :spree_comments, :user_id

    create_table :spree_comment_types do |t|
      t.string :name
      t.string :applies_to
      t.timestamps
    end

  end

  def self.down
    drop_table :spree_comments
    drop_table :spree_comment_types
  end
end
