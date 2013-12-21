Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "theme_admin_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= tab(:template_themes) %>",
                     :disabled => false)
