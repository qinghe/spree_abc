Spree::Core::Engine.routes.draw do

  # Add your extension routes here
  namespace :api, :defaults => { :format => 'json' } do
    resources :cities, :only => :index
  end
end
