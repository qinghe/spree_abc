
Spree.routes.admin_template_themes = Spree.pathFor('admin/template_themes')
Spree.routes.admin_page_layouts = function(template_theme_id) {
  return Spree.pathFor('admin/template_themes/'+template_theme_id+'/page_layouts')
}
Spree.routes.global_taxons_search = Spree.pathFor('api/taxons/global')

//Spree.routes.global_taxons_search = "<%= spree.global_api_taxons_url(:format => :json) %>";'

