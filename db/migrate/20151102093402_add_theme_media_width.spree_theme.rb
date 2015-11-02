# some section piece is clickable, like taxon name, product name, post name,
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable.
class AddThemeMediaWidth < ActiveRecord::Migration
  def change
    # a template has some compatible media width.
    create_table :spree_query_media do |t|
      t.string :name,:limit=>64
      t.string :medium_width, :limit=>128
    end

    create_table :spree_template_themes_query_media, :id => false do |t|
      t.references :template_theme
      t.references :query_medium
      t.integer    :position
    end

    if table_exists? 'spree_query_media'
      Spree::QueryMedium.create(name: 'Default', medium_width: 'all' )
    end

    add_column :spree_param_values, :pvalue1, :string, :limit=>2048
    add_column :spree_param_values, :pvalue2, :string, :limit=>2048
    add_column :spree_param_values, :pvalue3, :string, :limit=>2048

  end

end
