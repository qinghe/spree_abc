Spree::Core::Engine.add_routes do

  namespace :admin do
    resources :sites
  end
  post '/quick_lunch',:to => 'sites#quick_lunch', :as => :quick_lunch
  get 'new_site' => 'sites#new', :as => :new_site
  post 'create_site' => 'sites#create', :as => :create_site
  resources :sites, :only => [:show]

  if Rails.env.development?
    mount Spree::UserMailer::Preview => 'mail_view'
  end
end
