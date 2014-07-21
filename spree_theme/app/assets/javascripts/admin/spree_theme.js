//= require admin/spree_backend
//= require jquery.ajax
//= require admin/resource_autocomplete
jQuery(function ($) {
  $('#page_layout_tree_inner').bind('select_node.jstree', function (e, data) {
    var selected_node = data.rslt.obj
    var url = Spree.routes.admin_template_themes+'/'+selected_node.data('tid')+'/page_layout/'+selected_node.data('lid')+'/config'
    $.ajax({ url: url, dataType: "script"})
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
});
