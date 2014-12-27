//= require spree/backend
//= require jquery.ajax
//= require jquery.jeditable
//= require admin/resource_autocomplete

Spree.routes.admin_template_themes = Spree.pathFor('admin/template_themes')
Spree.routes.admin_page_layouts = function(template_theme_id) {
  return Spree.pathFor('admin/template_themes/'+template_theme_id+'/page_layouts')
}
Spree.routes.global_taxons_search = Spree.pathFor('api/taxons/global')

//Spree.routes.global_taxons_search = "<%= spree.global_api_taxons_url(:format => :json) %>";'


jQuery(function ($) {
  $('#page_layout_tree_inner').bind('select_node.jstree', function (e, data) {
    var selected_node = data.rslt.obj    
    var url = [Spree.routes.admin_page_layouts( selected_node.data('tid')),selected_node.data('lid'), selected_node.data('action') ].join('/')
    $.ajax({ url: url, type: 'GET', dataType: "script"})
  }).bind('deselect_all.jstree', function (e, data) {
    //$(this).find('select').hide()
  })
  .jstree(
    { themes:{ theme: "apple", url: "/assets/jquery.jstree/themes/apple/style.css" },
    // plugins: ["themes"]
      core : {  multiple: false,  animation: 0  }
    }      
  ); 
  //$('#page_layout_tree_inner select.select22').select2();
  
  
  $('#listing_template_themes .editable').editable(function(value, settings) {
	  var jquery_element = $(this)
      var url = Spree.routes.admin_template_themes+'/'+jquery_element.data('id')
      var submitdata = {};
      submitdata[settings.name] = value;
      $.ajax({ dataType: 'json', url: url, type: 'put',  data : submitdata   });             
      return(value);
    },        
    { //since dblclick would trigger click, for a link, we should not click,dblclick together
      event     : "dblclick",
      name      : "template_theme[title]",
      width     : '80%',
      height    : '25px',
      style  : "inherit" });
  $('#listing_template_themes form input:checkbox').change(
    function(){ $(this.form).trigger('submit'); }
  )
  $('#listing_template_themes form input:radio').change(
    function(){ $(this.form).trigger('submit'); }
  )
});
