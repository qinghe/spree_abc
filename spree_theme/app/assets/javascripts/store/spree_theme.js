//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.form
//= require jquery.layout
//= require jquery.ajax
//= require jssor.slider.one
//= require spree/frontend
//= require store/spree_theme.client
//= require store/spree_theme.routes
//= require interface.js
//= require jquery.jeditable.js
//= require turbolinks

$(document).ready(function() {
  if (typeof(g_is_preview) != 'undefined' && g_is_preview==true)
  {
    if (typeof(g_selector_gadget) == 'undefined' || g_selector_gadget == null) {
      g_selector_gadget = new SelectorGadget();
      g_selector_gadget.setMode('interactive');
    }

    $('body').layout({ applyDefaultStyles: true,
      stateManagement__enabled: true  //enable stateManagement - automatic cookie load & save enabled by default  
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
      $(this).parent().siblings('input').val($(this).attr('data-section-id'));
    });
    $("#section_select_dialog .dialog_close_button").click(function(){
      $.simplemodal.close();
    });
    $("#section_select_dialog .dialog_ok_button").click(function(){
       $('#selected_section_id').val($('#section_select_dialog [name="selected_section_id"]').val());

      submit_layout_tree_form( this );
      $.simplemodal.close();
    });
    // add, remove, move section

    //$('.remove_section_button').click(function(){
    //   var page_layout_id = $(this).data('id');
    //   if (confirm('Really?')) submit_layout_tree_form('del_self', page_layout_id )
    //})
    
  }  
});
function submit_layout_tree_form ( currentTarget ) {
  var target = $(currentTarget);
  var page_layout_id = target.data('id');

  var op = target.data('op');
  if(op=='list_section'){
    $('#layout_id').val(page_layout_id);
    $('#section_select_dialog').simplemodal({ minHeight:300,  minWidth: 600,
          overlayCss:{ 'background-color': 'gray' },
          containerCss: {'background-color': 'white', 'overflow' :'auto' }
    });
    return;
  }
  
  $('#op').val(op);
  // layout_id, selected_section_id could be null.
  if (page_layout_id) $('#layout_id').val(page_layout_id);
  $('#layout_tree_form').trigger('submit');
}
