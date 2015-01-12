#= require_tree .

$ ->
  if ($ '#checkout').is('*')
    SinglePageCheckout.StepHandler.disableSteps ($ '.checkout_content.disabled-step')
