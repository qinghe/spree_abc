# This migration comes from spree_flexi_variants (originally 20110225135642)
class CreateAdHocOptionTypes < ActiveRecord::Migration
  def self.up
    create_table :spree_ad_hoc_option_types do |t|
      t.integer :product_id
      t.integer :option_type_id
      t.integer :position, :null => false, :default => 0
      t.string :price_modifier_type, :null => true, :default => nil
      t.boolean :is_required, :default => false
      t.timestamps
    end

    create_table :spree_ad_hoc_option_values do |t|
      t.integer  :ad_hoc_option_type_id
      t.integer  :option_value_id
      t.integer  :position
      t.boolean :selected 
      t.decimal :price_modifier, :null => false, :default => 0, :precision => 8, :scale => 2
      t.decimal :cost_price_modifier, :precision => 8, :scale => 2
      t.timestamps
    end

    create_table :spree_product_customizations do |t|
      t.integer :line_item_id
      t.integer :product_customization_type_id
      t.timestamps
    end

    create_table :spree_product_customization_types do |t|
      t.string :name
      t.string :presentation
      t.string :description
      t.timestamps
    end

    create_table :spree_product_customization_types_products, :id => false do |t|
      t.integer :product_customization_type_id
      t.integer :product_id
    end

    create_table :spree_ad_hoc_variant_exclusions do |t|
      t.integer :product_id
      t.timestamps
    end

    create_table :spree_customized_product_options do |t|
      t.integer :product_customization_id
      t.integer :customizable_product_option_id
      t.string :value
      t.timestamps
    end

    create_table :spree_customizable_product_options do |t|
      t.integer  :product_customization_type_id
      t.integer  :position
      t.string   :presentation,       :null => false
      t.string   :name,        :null => false
      t.string   :description
      #t.string   :data_type, :default => "string"
      #t.boolean  :is_required, :default => false
      t.timestamps
    end

    create_table :spree_excluded_ad_hoc_option_values do |t|
      t.integer :ad_hoc_variant_exclusion_id
      t.integer :ad_hoc_option_value_id
    end
    create_table :spree_ad_hoc_option_values_line_items do |t|
      t.integer :line_item_id
      t.integer :ad_hoc_option_value_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_hoc_option_types
    drop_table :ad_hoc_option_values
    drop_table :product_customizations
    drop_table :product_customization_types_products
    drop_table :product_customization_types
    drop_table :ad_hoc_variant_exclusions
    drop_table :customized_product_options
    drop_table :customizable_product_options
    drop_table "excluded_ad_hoc_option_values"
    drop_table :ad_hoc_option_values_line_items

  end
end
