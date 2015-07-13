
#map.namespace :admin do |admin|
#  admin.resources :comments
#  admin.resources :comment_types
#
#  admin.resources :orders, :member => {:comments => :get} do |order|
#    order.resources :shipments, :member => {:comments => :get}
#  end
#end
#

Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :comments
    resources :comment_types

    resources :orders do
      member do
        get :comments
      end

      resources :shipments do
        member do
         get :comments
       end
      end
    end
  end

#match '/admin/comments' => 'admin/comments', :via => [:get, :post]
#  match '/admin/comment_types' => 'admin/comment_types', :via => [:get, :post]
end

