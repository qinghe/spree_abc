Deface::Override.new(:virtual_path     => "spree/admin/option_types/edit",
                     :name             => "admin_option_value_table_headers",
                     :replace_contents => "thead[data-hook=option_header]",
                     :partial          => "spree/admin/option_types/table_header",
                     :disabled         => false)

Deface::Override.new(:virtual_path   => "spree/admin/option_types/edit",
                     :name           => "admin_option_value_table_empty_colspan",
                     :set_attributes => "tr[data-hook=option_none] td",
                     :attributes     => { :colspan => 5 },
                     :disabled       => false)

#Deface::Override.new(:virtual_path   => "spree/admin/option_types/edit",
#                     :name           => "admin_sortable_option_values",
#                     :set_attributes => "table.index",
#                     :attributes     => {
#                       "class"              => "index sortable",
#                       "data-sortable-link" => "/admin/option_values/update_positions"
#                     },
#                     :disabled       => false)
