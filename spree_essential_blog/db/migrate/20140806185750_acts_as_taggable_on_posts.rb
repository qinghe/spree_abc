class ActsAsTaggableOnPosts < ActiveRecord::Migration
  def self.up
    return if table_exists? :tags
    
    create_table :spree_tags do |t|
      t.string :name
    end

    create_table :spree_taggings do |t|
      t.references :tag
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true
      t.string :context
      t.datetime :created_at
    end

    add_index :spree_taggings, :tag_id
    add_index :spree_taggings, [:taggable_id, :taggable_type, :context], :name=>"spree_taggings_id_type_context"
  end

  def self.down
    return unless table_exists? :spree_tags
    drop_table :spree_tags
    drop_table :spree_taggings
  end
  
end
