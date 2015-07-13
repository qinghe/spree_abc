Spree.ready ($) ->

  Spree.routes.cities_search = "/api/cities"
  if ($ '#checkout_form').is('form')
     ($ '#checkout_form').validate()

  if ($ '#checkout_form_address').is('*')

    getStateId = (region) ->
      $('#' + region + 'state select').val()

    Spree.updateCity = (region) ->
      stateId = getStateId(region)
      if stateId?
        unless Spree.Checkout[stateId]?
          $.get Spree.routes.cities_search, {state_id: stateId}, (data) ->
            Spree.Checkout[stateId] =
              states: data.states
              states_required: data.states_required
            Spree.fillAddress(Spree.Checkout[stateId], region, 'city')
        else
          Spree.fillAddress(Spree.Checkout[stateId], region, 'city')

    Spree.fillAddress = (data, region, area) ->
      statesRequired = data.states_required
      states = data.states

      statePara = ($ '#' + region + area)
      stateSelect = statePara.find('select')
      stateInput = statePara.find('input')
      stateSpanRequired = statePara.find('state-required')
      if states.length > 0
        selected = parseInt stateSelect.val()
        stateSelect.html ''
        statesWithBlank = [{ name: '', id: ''}].concat(states)
        $.each statesWithBlank, (idx, state) ->
          opt = ($ document.createElement('option')).attr('value', state.id).html(state.name)
          opt.prop 'selected', true if selected is state.id
          stateSelect.append opt

        stateSelect.prop('disabled', false).show()
        stateInput.hide().prop 'disabled', true
        statePara.show()
        stateSpanRequired.show()
        stateSelect.addClass('required') if statesRequired
        stateInput.removeClass('required')
      else
        stateSelect.hide().prop 'disabled', true
        stateInput.show()
        if statesRequired
          stateSpanRequired.show()
          stateInput.addClass('required')
        else
          stateInput.val ''
          stateSpanRequired.hide()
          stateInput.removeClass('required')
        statePara.toggle(!!statesRequired)
        stateInput.prop('disabled', !statesRequired)
        stateInput.removeClass('hidden')
        stateSelect.removeClass('required')
    ($ '#bstate select').change ->
      Spree.updateCity 'b'
    Spree.updateCity 'b'
