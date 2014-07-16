//= require jquery
//= require jquery.ui.dialog
//= require jquery.ui.dialog
//= require jquery_ujs
//= require jquery.form
//= require jquery.layout
//= require jquery.ajax
//= require jssor.slider.one
//= require store/spree_frontend
//= require store/spree_theme.client
//= require interface.js
//= require jquery.jeditable.js

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
    $("#layout_tree_form .click_editable").each(function(index,element){
    	var jquery_element = $(element);
    	jquery_element.editable(function(value, settings) { 
            var url = Spree.routes.admin_template_theme_path+'/page_layout/'+jquery_element.data('lid');
            var submitdata = {};
            submitdata[settings.name] = value;
            submitdata[settings.id] = self.id;
            $.ajax({ dataType: 'json', url: url, type: 'put',  data : submitdata,
                success: function(data){
                  jquery_element.html(data.page_layout.title);
                }
            });             
            return(value);
          },    		
    			{ //since dblclick would trigger click, for a link, we should not click,dblclick together
            event     : "click_editable",
            name      : "page_layout[title]",
            style  : "inherit" });
      jquery_element.click(function(){
        if($('#page_layout_editable').is(':checked')){
          jquery_element.trigger('click_editable')
        }else{
          $('#selected_page_layout_id').val(jquery_element.data('lid'));
          $('#layout_editor_form').trigger('submit')
        }          
      });        

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

