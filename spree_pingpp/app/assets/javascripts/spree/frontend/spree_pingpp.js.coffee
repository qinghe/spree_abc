//= require 'pingpp-pc'
Spree.routes.handle_pingpp = Spree.pathFor('checkout/handle_pingpp')

Spree.ready ($) ->
  Spree.onPingppPayment = () ->
    ($ '#checkout').delegate '#checkout_form_payment', 'submit', (event) ->
      alert('yes it is called in spree_pingpp')
      #event.preventDefault();
      $('.pingpp_channel').click ->
        $.ajax
          type: 'patch'
          url: Spree.routes.handle_pingpp
          data: $('#checkout_form_payment').serialize()
          success: (charge)->
            pingppPc.createPayment charge, (result, err) ->
              if result == "success"

              else if result == "fail"
                alert(err)
              else if result == "cancel"
                alert(err)
        false

  Spree.onPingppPayment()
