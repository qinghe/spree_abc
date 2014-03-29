Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "theme_admin_tab",
                     :class => "tab-with-icon",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= tab(:template_themes, :route=>'native_admin_template_themes',:icon=>'icon-puzzle-piece',:match_path => '/template') %>",
                     :disabled => false)
