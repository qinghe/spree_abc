window.SinglePageCheckout ||= {}

class SinglePageCheckout.StepHandler
  constructor: (@$step, @partial, @error) ->
    #@constructor.disableSteps ($ '.checkout-content')

  #Class Methods
  @_toggleElements: ($elements, status) ->
    $elements.toggleClass 'disabled-step', status
    $elements.find('#checkout-summary, .errorExplanation').toggle !status
    

  @disableSteps: ($elements) ->
    @_toggleElements $elements, true

  @enableStep: ($element) ->
    css_classes = 'current-step enabled-step disabled-step'
    $element.removeClass(css_classes).addClass( 'current-step')
    $element.prevAll().removeClass(css_classes).addClass('enabled-step' )
    $element.nextAll().removeClass(css_classes).addClass('disabled-step' )
    
    Spree.onAddress() if $element.data('step') is 'address'
    Spree.onPayment() if $element.data('step') is 'payment'
    
    $element.find('.form-wrapper').slideDown(300);
    
    $element.siblings('.disabled-step, .enabled-step').find('.form-wrapper').slideUp(300);

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

   