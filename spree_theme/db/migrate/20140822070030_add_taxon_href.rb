class AddTaxonHref < ActiveRecord::Migration
  def change
    # give a menu item more html attributes,  ex. href,  onclick.
    # a menu item may link to another url, outer links, inner link
    # a menu item may have onclick event, add_to_bookmark, mail_to ..    
    add_column :spree_taxons, :html_attributes, :string
  end

end
