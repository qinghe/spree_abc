# This migration comes from spree_theme (originally 20140814000001)
class AddDataSourceParam < ActiveRecord::Migration
  def change
    add_column :spree_page_layouts, :data_source_param, :string, :default => ''
    add_column :spree_section_piece_params, :editable_condition, :string, :default => ''    
  end
end
