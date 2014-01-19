//= require admin/spree_backend
//= require jquery.ajax
jQuery(function ($) {
  $('#page_layout_tree_inner').jstree(
    {themes:{ theme: "apple", url: "/assets/jquery.jstree/themes/apple/style.css" }
    // plugins: ["themes"]
    }      
  ); 
  
});
