Spree::Core::Engine.add_routes do

  namespace :admin do
    resources :sites
  end
  # one click get form to trial
  get 'one_click_trial' => 'sites#one_click_trial', :as => :one_click_trial

  # bottom signup form
  post 'quick_lunch',:to => 'sites#quick_lunch', :as => :quick_lunch

  # create site with template_theme
  get 'new_site' => 'sites#new', :as => :new_site
  post 'create_site' => 'sites#create', :as => :create_site
  resources :sites, :only => [:show]

  #if Rails.env.development?
  #  mount Spree::UserMailer::Preview => 'mail_view'
  #end
end
