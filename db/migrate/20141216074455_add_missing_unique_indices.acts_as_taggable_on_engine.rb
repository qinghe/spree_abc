# This migration comes from acts_as_taggable_on_engine (originally 2)
class AddMissingUniqueIndices < ActiveRecord::Migration
  def self.up
    unless index_name_exists?(:tags, 'index_tags_on_name','no-indexes-method' )
      add_index :tags, :name, unique: true
    end
    if index_name_exists?(:taggings, 'index_taggings_on_tag_id','no-indexes-method' )
      remove_index :taggings, :tag_id
    end
    remove_index :taggings, :name=>"taggings_id_type_context"
    add_index :taggings,
              [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
              unique: true, name: 'taggings_idx'
  end

  def self.down
    remove_index :tags, :name

    remove_index :taggings, name: 'taggings_idx'
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context], :name=>"taggings_id_type_context"
  end
end
