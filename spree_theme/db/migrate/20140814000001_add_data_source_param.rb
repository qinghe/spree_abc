class AddDataSourceParam < ActiveRecord::Migration
  def change
    # section param effect on content, we use data_source_param
    # section param effect on css, we use content_param
    add_column :spree_page_layouts, :data_source_param, :string, :default => ''
    add_column :spree_section_piece_params, :editable_condition, :string, :default => ''
    # editable_condition comma separated string,  available values ['data_source:gpvs,data_source:blog']      
  end
end
