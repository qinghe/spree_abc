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

    if table_exists?( :spree_user_terminals )

      pc = Spree::UserTerminal.create(name: 'PC', medium_width: 'all' )
      phone = Spree::UserTerminal.create(name: 'Cellphone', medium_width: 'all' )
      pad = Spree::UserTerminal.create(name: 'Pad', medium_width: 'all' )

    end

  end

end
