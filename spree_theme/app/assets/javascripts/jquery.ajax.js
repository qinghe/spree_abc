
handle_ajax_error = function(XMLHttpRequest, textStatus, errorThrown) {
  return $("#ajax_error").show().html("<strong>" + server_error + "</strong><br />" + taxonomy_tree_error);
};

function ajax_post (url, form, data_type, callback) {
  $.ajax({type:'post',data:$("#"+form+" :input").serialize(), url:url,dataType:data_type, success:callback });   
}

/*   start js for ajax  */
function ajax_get(url)
{ 
  $.ajax({type:'get', url:url,dataType:'script'});    
}