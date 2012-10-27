Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  resources :cities, :only => :index
end
