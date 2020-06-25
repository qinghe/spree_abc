# This migration comes from spree_theme (originally 20160530004614)
class AddDataSourceOrderByToPageLayouts < ActiveRecord::Migration
  def change
    add_column :spree_page_layouts, :data_source_order_by, :string
  end
end
