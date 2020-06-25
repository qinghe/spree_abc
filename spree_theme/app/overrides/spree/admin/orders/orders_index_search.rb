Deface::Override.new(:virtual_path     => "spree/admin/orders/index",
                     :name             => "admin_orders_index_search",
                     :replace_contents => "div[data-hook=admin_orders_index_search]",
                     :partial          => "spree/admin/orders/search_form",
                     :disabled         => false)
