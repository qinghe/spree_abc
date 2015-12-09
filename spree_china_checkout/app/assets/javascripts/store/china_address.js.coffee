Spree.ready ($) ->

  Spree.routes.cities_search = Spree.pathFor("api/cities")
  Spree.routes.districts_search = Spree.pathFor("api/districts")
  if ($ '#checkout_form').is('form')
     ($ '#checkout_form').validate()

  if ($ '#checkout_form_address').is('*')

    getStateId = (region) ->
      $('#' + region + 'state select').val()
    getCityId = (region) ->
      $('#' + region + 'city select').val()

    Spree.updateCity = (region) ->
      stateId = getStateId(region)
      if stateId?
        unless Spree.Checkout[stateId]?
          $.get Spree.routes.cities_search, {state_id: stateId}, (data) ->
            Spree.Checkout[stateId] =
              addresses: data.cities
              addresses_required: data.cities_required
            Spree.fillAddress(Spree.Checkout[stateId], region, 'city')
        else
          Spree.fillAddress(Spree.Checkout[stateId], region, 'city')
    Spree.updateDistrict = (region) ->
      stateId = getStateId(region)
      cityId = getCityId(region)

      if cityId?
        city_key = stateId+'_'+cityId
        unless Spree.Checkout[city_key]?
          $.get Spree.routes.districts_search, {city_id: cityId}, (data) ->
            Spree.Checkout[city_key] =
              addresses: data.districts
              addresses_required: data.districts_required
            Spree.fillAddress(Spree.Checkout[city_key], region, 'district')
        else
          Spree.fillAddress(Spree.Checkout[city_key], region, 'district')

    Spree.fillAddress = (data, region, area) ->
      states = data.addresses
      statesRequired = data.addresses_required

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
    ($ '#bcity select').change ->
      Spree.updateDistrict 'b'
#    Spree.updateCity 'b'
