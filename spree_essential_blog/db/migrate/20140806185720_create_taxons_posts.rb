class CreateTaxonsPosts < ActiveRecord::Migration
  def self.up
    create_table :spree_taxons_posts, :id => false, :force => true do |t|
      t.integer :post_id
      t.integer :post_category_id
    end
  end

  def self.down
    drop_table :spree_taxons_posts
  end
end
