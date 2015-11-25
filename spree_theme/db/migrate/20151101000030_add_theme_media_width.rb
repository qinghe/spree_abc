# some section piece is clickable, like taxon name, product name, post name,
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable.
class AddThemeMediaWidth < ActiveRecord::Migration
  def change

    # a template has some compatible media width.
    create_table :spree_user_terminals do |t|
      t.string :name,:limit=>64
      t.string :medium_width, :limit=>128
    end


    add_reference( :spree_payment_methods, :user_terminal )
    add_reference( :spree_template_themes, :user_terminal )
    add_reference( :spree_orders, :user_terminal )

  end

end
