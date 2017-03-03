class CreateTemplateTexts < ActiveRecord::Migration
  def self.up
    create_table :spree_template_texts do |t|
      t.integer :site_id,     :null => false, :default => 0
      t.string :name
      t.text :body
      t.string :slug
      t.timestamps null: false
    end
    add_index(:spree_template_texts, :slug)
  end

  def self.down
    drop_table :spree_template_texts
  end
end
