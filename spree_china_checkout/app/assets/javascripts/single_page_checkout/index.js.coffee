#= require_tree .

$ ->
    ($ '#checkout').delegate '#checkout_form_payment', 'submit', ->
      $("#dialog .dialog_content" ).html( $("#checkout .wait-for-payment").clone() );
      $("#dialog").simplemodal({appendTo:'#page-inner',closeHTML:'', escClose:true, overlayClose:true});

    
