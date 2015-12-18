Spree.ready ($) ->

  Spree.routes.cities_search = Spree.pathFor("api/cities")
  Spree.routes.districts_search = Spree.pathFor("api/districts")

  Spree.onAddress = () ->
    if ($ '#checkout_form').is('form')
       ($ '#checkout_form').validate()

    if ($ '#checkout_form_address').is('*')

      getCountryId = (region) ->
        $('#' + region + 'country select').val()
      getStateId = (region) ->
        $('#' + region + 'state select').val()
      getCityId = (region) ->
        $('#' + region + 'city select').val()

      Spree.updateCity = (region) ->
        countryId = getCountryId(region)
        stateId = getStateId(region)
        if stateId? && stateId!=''
          state_key = countryId+'_'+stateId
          unless Spree.Checkout[state_key]?
            $.get Spree.routes.cities_search, {state_id: stateId}, (data) ->
              Spree.Checkout[state_key] =
                addresses: data.cities
                addresses_required: data.cities_required
              Spree.fillAddress(Spree.Checkout[state_key], region, 'city')
              Spree.updateDistrict('b')
          else
            Spree.fillAddress(Spree.Checkout[state_key], region, 'city')
        else
          Spree.fillAddress( { }, region, 'city')


      Spree.updateDistrict = (region) ->
        countryId = getCountryId(region)
        stateId = getStateId(region)
        cityId = getCityId(region)

        if cityId? && cityId!=''
          city_key = countryId+'_'+stateId+'_'+cityId
          unless Spree.Checkout[city_key]?
            $.get Spree.routes.districts_search, {city_id: cityId}, (data) ->
              Spree.Checkout[city_key] =
                addresses: data.districts
                addresses_required: data.districts_required
              Spree.fillAddress(Spree.Checkout[city_key], region, 'district')
          else
            Spree.fillAddress(Spree.Checkout[city_key], region, 'district')
        else
          Spree.fillAddress( { }, region, 'district')

      Spree.fillAddress = (data, region, area) ->
        prompt = switch area
          when 'state' then please_select_state_prompt
          when 'city' then please_select_city_prompt
          when 'district' then please_select_district_prompt
          else ''
        states = data.addresses || []
        statesRequired = data.addresses_required

        statePara = ($ '#' + region + area)
        stateSelect = statePara.find('select')
        #stateSpanRequired = statePara.find( '[id$="'+ area +'-required"]' )
        selected = parseInt stateSelect.val()
        stateSelect.html ''
        statesWithBlank = [{ name: prompt, id: ''}].concat(states)
        $.each statesWithBlank, (idx, state) ->
          opt = ($ document.createElement('option')).attr('value', state.id).html(state.name)
          opt.prop 'selected', true if selected is state.id
          stateSelect.append opt

        stateSelect.addClass('required') if statesRequired

    ($ '#bstate select').change ->
      Spree.updateCity 'b'
    ($ '#bcity select').change ->
      Spree.updateDistrict 'b'
#    Spree.updateCity 'b'
  Spree.onAddress()
