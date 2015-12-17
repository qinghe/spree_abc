Spree::Core::Engine.add_routes do

  # Add your extension routes here
  namespace :api, :defaults => { :format => 'json' } do
    resources :cities, :only => :index
    resources :districts, :only => :index
  end
end
