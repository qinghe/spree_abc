# some section piece is clickable, like taxon name, product name, post name,
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable.
class AddThemeMediaWidth < ActiveRecord::Migration
  def change
    # a template has some compatible media width.
    add_column :spree_template_themes, :media_width, :string, :limit=>128
    add_column :spree_template_themes, :media_width1, :string, :limit=>128
    add_column :spree_template_themes, :media_width2, :string, :limit=>128
    add_column :spree_template_themes, :media_width3, :string, :limit=>128

    add_column :spree_param_values, :pvalue1, :string, :limit=>2048
    add_column :spree_param_values, :pvalue2, :string, :limit=>2048
    add_column :spree_param_values, :pvalue3, :string, :limit=>2048

  end

end
