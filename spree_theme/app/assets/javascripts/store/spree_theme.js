//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require jquery.form
//= require jquery.layout
//= require jquery.ajax
//= require jssor.slider.one
//= require store/spree_frontend
//= require store/spree_theme.client
//= require interface.js

$(document).ready(function() {
  if (typeof(g_is_preview) != 'undefined' && g_is_preview==true)
  {
    if (typeof(g_selector_gadget) == 'undefined' || g_selector_gadget == null) {
      g_selector_gadget = new SelectorGadget();
      g_selector_gadget.setMode('interactive');
    }

    $('body').layout({ applyDefaultStyles: true,
      stateManagement__enabled: true // enable stateManagement - automatic cookie load & save enabled by default  
    });
    
    $("#section_select_dialog").dialog({ autoOpen: false,
                                         buttons: { "Cancel": function() { $(this).dialog("close"); },
                                                    "OK": function() { submit_layout_tree_form( 'add_child',null, $(this).find('[name="selected_section_id"]').val());
                                                                       $(this).dialog("close"); }
                                                  },  
                                         width:500,height:245 });
    $("#section_select_dialog .titles li").click(function(){
      $(this).parent().children().removeClass('selected');
      $(this).addClass('selected'); 
      $(this).parent().next().children().removeClass('selected');
      $(this).parent().next().children().eq($(this).index()).addClass('selected');
      $(this).parent().siblings('input').val($(this).attr('data-section-id'))
    });
  }  
})
function submit_layout_tree_form (op, layout_id, selected_section_id) {
  $('#op').val(op);
  // layout_id, selected_section_id could be null.
  if (layout_id) $('#layout_id').val(layout_id);
  if (selected_section_id) $('#selected_section_id').val(selected_section_id);
  $('#layout_tree_form').trigger('submit');
}
