window.SinglePageCheckout ||= {}

class SinglePageCheckout.StepHandler
  constructor: (@$step, @partial, @error) ->
    @constructor.disableSteps ($ '.checkout-content')

  #Class Methods
  @_toggleElements: ($elements, status) ->
    $elements.toggleClass 'disabled-step', status
    $elements.find('form input').prop 'disabled', status
    $elements.find('#checkout-summary, .errorExplanation').toggle !status

  @disableSteps: ($elements) ->
    @_toggleElements $elements, true

  @enableStep: ($element) ->
    @_toggleElements $element, false
    Spree.onAddress() if $element.data('step') is 'address'
    Spree.onPayment() if $element.data('step') is 'payment'

  #Instance Methods
  _prependError: ->
    $p = ($ '<p>', class: 'checkout-error', text: @error)
    @$step.find('form.edit_order').
      prepend $p

  _renderPartial: ->
    @$step.html @partial

  replaceCheckoutStep: ->
    @_renderPartial()
    @_prependError() if !!@error
    @constructor.enableStep @$step

