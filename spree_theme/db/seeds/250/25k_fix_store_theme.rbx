# it would cause error while spree_theme:reload, NoMethodError: undefined method `site'
Spree::Store.all.each{|store|
  if store.theme_id == 0
    if store.site.theme_id>0
      store.update_attribute :theme_id, store.site.theme_id
    else
      puts "store #{store.name} have no theme"
    end
  end
}
