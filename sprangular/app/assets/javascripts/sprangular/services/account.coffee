Sprangular.service "Account", ($http, _, $q, Cart, Flash) ->

  service =

    fetched: false
    isLogged: false

    init: ->
      @clear()

      $http.get '/api/account'
        .success (data) ->
          service.populateAccount(data)
          service.fetched = true
        .error (data) ->
          service.isLogged = false
          service.fetched = true

    reload: ->
      @fetched = false
      $http.get '/api/account'
        .success (data) ->
          service.populateAccount(data)
          Cart.reload()
          service.fetched = true
        .error (data) ->
          service.isLogged = false

    populateAccount: (data) ->
      @user = Sprangular.extend(data, Sprangular.User)

      @isLogged = true
      @email = data.email

    clear: ->
      @fetched = false
      @user = {}
      @isLogged = false
      @email = null

    login: (data) ->
      params =
        'spree_user[email]': data.email,
        'spree_user[password]': data.password
      $http.post '/spree/login.js', $.param params
        .success (data) ->
          service.reload().then (data) ->
            Cart.reload()
            Flash.success 'Successfully signed in'
        .error ->
          Flash.error 'Sign in failed'

    logout: ->
      $http.get '/spree/logout'
        .success (data) ->
          service.isLogged = false
          service.clear()
          Cart.init()

    signup: (data) ->
      params =
        spree_user: data

      $http.post('/api/account', $.param(params))
        .success (data) ->
          service.reload().then (data) ->
            Cart.reload()

    forgotPassword: (data) ->
      params =
        spree_user: data
      $http.post '/api/passwords', $.param params
        .success (data) ->
          service.reload().then (data) ->
            Cart.reload()

    resetPassword: (data) ->
      params =
        spree_user: data
      $http.put '/api/passwords/'+data.reset_password_token, $.param params
        .success (data) ->
          service.reload().then (data) ->
            Cart.reload()

    save: (data) ->
      params =
        spree_user: data
      $http.put '/api/account', $.param params
        .success (data) ->
          service.reload().then (data) ->
            Flash.success 'Account updated'
        .error ->
          Flash.error 'Save failed'

    deleteCard: (card) ->
      cards = @user.creditCards

      $http.delete("/api/credit_cards/#{card.id}")
        .success (data) ->
          i = cards.indexOf card
          cards.splice(i, 1) unless i is -1

  service.init()
  service
