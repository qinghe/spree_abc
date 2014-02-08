Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :sites
  end
  match 'new_site' => 'sites#new', :as => :new_site
  resources :sites, :only => [:show]

  if Rails.env.development?
    mount Spree::UserMailer::Preview => 'mail_view'
  end
end

#map.namespace :admin do |admin|
#  admin.resources :sites
  ## admin.resources :taxonomies, :has_many => [:variants, :images, :product_properties] do |product|
#end  
