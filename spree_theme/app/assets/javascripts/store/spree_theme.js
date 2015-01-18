//= require jquery/jquery
//= require jquery_ujs
//= require jquery.form
//= require jquery.layout
//= require jquery.ajax
//= require jssor.slider.one
//= require spree/frontend
//= require store/spree_theme.client
//= require interface.js
//= require jquery.jeditable.js
//= require jquery.floatBar.js

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
    
    //$("#section_select_dialog").dialog({ autoOpen: false,
    //                                     buttons: { "Cancel": function() { $(this).dialog("close"); },
    //                                                "OK": function() { submit_layout_tree_form( 'add_child',null, $(this).find('[name="selected_section_id"]').val());
    //                                                                   $(this).dialog("close"); }
    //                                              },  
    //                                     width:500,height:245 });
    
    $("#section_select_dialog .titles li").click(function(){
      $(this).parent().children().removeClass('selected');
      $(this).addClass('selected'); 
      $(this).parent().next().children().removeClass('selected');
      $(this).parent().next().children().eq($(this).index()).addClass('selected');
      $(this).parent().siblings('input').val($(this).attr('data-section-id'))
    });
    $("#section_select_dialog .dialog_close_button").click(function(){
      $.modal.close();
    })
    $("#section_select_dialog .dialog_ok_button").click(function(){
      submit_layout_tree_form( 'add_child',null, $('#section_select_dialog [name="selected_section_id"]').val());
      $.modal.close();
    })
    // add, remove, move section
    $('.add_section_button').click(function(){
        var page_layout_id = $(this).data('id');
        $('#layout_id').val(page_layout_id);
        $('#section_select_dialog').modal({ minHeight:300,  minWidth: 600 });
    })
    $('.remove_section_button').click(function(){
        var page_layout_id = $(this).data('id');
        if (confirm('Really?')) submit_layout_tree_form('del_self', page_layout_id )
    })
    $('.move_section_to_left_button').click(function(){
        var page_layout_id = $(this).data('id');
        submit_layout_tree_form('move_left',page_layout_id )
    })
    $('.move_section_to_right_button').click(function(){
        var page_layout_id = $(this).data('id');
        submit_layout_tree_form('move_right',page_layout_id )
    })
    $('.promote_section_button').click(function(){
        var page_layout_id = $(this).data('id');
        submit_layout_tree_form('promote',page_layout_id )
    })
    $('.demote_section_button').click(function(){
        var page_layout_id = $(this).data('id');
        submit_layout_tree_form('demote',page_layout_id )
    })
  }  
})
function submit_layout_tree_form (op, layout_id, selected_section_id) {
  $('#op').val(op);
  // layout_id, selected_section_id could be null.
  if (layout_id) $('#layout_id').val(layout_id);
  if (selected_section_id) $('#selected_section_id').val(selected_section_id);
  $('#layout_tree_form').trigger('submit');
}

