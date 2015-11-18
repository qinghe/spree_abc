#= require_tree .

$ ->
  ($ '#checkout').delegate 'a.previous', 'click', ->
    SinglePageCheckout.StepHandler.enableStep $(this).parents('.checkout-content')
    return false

  ($ '#checkout').delegate '#checkout_form_payment', 'submit', (event) ->
    $(".dialog_content" ).html( $("#checkout .wait-for-payment").clone() );
    $(".u_dialog").simplemodal({appendTo:'#page-inner',closeHTML:'', escClose:true, overlayClose:true});
