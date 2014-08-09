Deface::Override.new(:virtual_path => "spree/admin/shared/_routes",
                     :name => "theme_routes",
                     :insert_bottom => "script",
                     :text => 'Spree.routes.admin_template_themes = "<%= spree.admin_template_themes_url %>;"'
                     )
