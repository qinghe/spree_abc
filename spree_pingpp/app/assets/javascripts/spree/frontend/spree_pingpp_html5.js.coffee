// for wap site html5 page
//= require 'pingpp'
Spree.routes.handle_pingpp = Spree.pathFor('checkout/handle_pingpp')

Spree.ready ($) ->
  Spree.onPingppPayment = () ->
    if ($ '#checkout_form_payment').is('*')
      $('.pingpp_channel').click ->
        $( '#pingpp_channel' ).val( $(this).data('pingpp_channel') )
        $.ajax
          type: 'patch'
          url: Spree.routes.handle_pingpp
          data: $('#checkout_form_payment').serialize()
          success: (charge)->
            pingpp.createPayment charge, (result, err) ->
              if result == "success"

              else if result == "fail"
                alert(err)
              else if result == "cancel"
                alert(err)
        false

  Spree.onPingppPayment()
