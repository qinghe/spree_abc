//= require jquery.ajax
//= require interface.js

$(document).ready(function() {

  if (typeof(g_client_info) != 'undefined' && g_client_info.is_preview==true)
  {
    if (typeof(g_selector_gadget) == 'undefined' || g_selector_gadget == null) {
      g_selector_gadget = new SelectorGadget();
      g_selector_gadget.setMode('interactive');
    }
    $( "#editor_panel a.close" ).click(
      function() { $(this).parent().hide(); $( "#editor_panel_icon" ).show();}
    );
    $( "#editor_panel_icon" ).click(
      function() { $( "#editor_panel" ).show(); }
    );

    //$('body').layout({ applyDefaultStyles: true,
    //  stateManagement__enabled: true  //enable stateManagement - automatic cookie load & save enabled by default
    //});

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

    // event is erase when layout tree updated.
    $("#layout_tree_form .click_editable").editable(function(value, settings) {
    	  var jquery_element = $(this);
        var url = Spree.routes.admin_page_layouts( jquery_element.data('tid') )+'/'+jquery_element.data('lid');
        var submitdata = {};
        submitdata[settings.name] = value;
        //submitdata[settings.id] = self.id;
        $.ajax({ dataType: 'json', url: url, type: 'put',  data : submitdata,
            success: function(data){
              // data is null, "nocontent" returned
              // jquery_element.html(data.page_layout.title);
            }
        });
        return(value);
      },
      { //since dblclick would trigger click, for a link, we should not click,dblclick together
        event     : "click_editable",
        name      : "page_layout[title]",
        cssclass : "editable",
        style  : "inherit"
        });

    $(document).on( 'click',"#layout_tree_form .click_editable",function(){
        self = $(this);
        if($('#page_layout_editable').is(':checked')){
        	// check event.editable to see editable initialized or not
        	// $(this).data('event.editable', settings.event);
          self.trigger('click_editable');
        }else{
          $('#selected_page_layout_id').val(self.data('lid'));
          $('#layout_editor_form').trigger('submit');
        }
    });

    $(document).on('mouseover',"#editors .tabs li", function(){
      $(this).parent().find('a').removeClass('selected');
      $(this).find('a').addClass('selected');
      $(this).parent().next().children().hide();
      $(this).parent().next().children().eq($(this).index()).show();
      $("#selected_editor_id").val($(this).attr('data-id'));
    });

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
