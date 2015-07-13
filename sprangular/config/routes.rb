Sprangular::Engine.routes.draw do
  scope module: 'sprangular' do

  
  #  root to: 'home#index'

    scope '/api', defaults: {format: :json} do
      post 'facebook/fetch'

      resources :taxonomies0, only: :index, controller: :taxonomies
      get 'taxons/*permalink', to: 'taxons#show'
      resources :products0, only: [:index, :show], controller: :products
      resource :cart do
        post :add_variant
        put :update_variant
        put :change_variant
        put :remove_adjustment
        delete :remove_variant
      end
      resource :account
   #   resources :passwords
   #   resources :credit_cards
   #   resources :countries, only: :index
   #   resources :shipping_rates, only: :index
    end
  end

  put 'api/checkouts/:id/quick_update', to: 'spree/api/checkouts#quick_update'
end

