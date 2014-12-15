# This migration comes from spree_essential_blog (originally 20140806185730)
class CreatePostProducts < ActiveRecord::Migration
  def self.up
    create_table :spree_post_products do |t|
      t.references :post
      t.references :product
      t.integer    :position
    end
  end

  def self.down
    drop_table :spree_post_products
  end
end