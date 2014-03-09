Spree::Core::Engine.routes.prepend do
  root :to => 'template_themes#page'
  # Add your extension routes here
  resources :template_themes do
     member do
       get :preview # add function preview_template_theme_path
       #get :editor
       get :edit_layout # modify page_layout
       post :get_param_values # to support post data>1024byte
       post :update_param_value
       post :update_layout_tree
       get :build
       get :generate_assets
     end

     collection do
       get :preview # add function preview_template_themes_path
       get 'publish'
       get 'upload_file_dialog'
       post 'upload_file_dialog'
       post :assign
     end
  end
  
  match '(/:c(/:r))' => 'template_themes#page', :c => /[\d]+/
  #match 'preview(/:c(/:r))' => 'template_themes#preview' #preview home
 
  namespace :admin do
    resources :template_themes do
      collection do
        get :native
        get :foreign
      end
      member do
        get :config # assign resource(menu, image)
        get :prepare_import # assign resource(menu, image)
        post :copy
        post :release
        post :import
        post :apply
        
      end
      resources :page_layout do
        member do
          post :update_config
        end
      end
    end
  end
  post '/quick_lunch',:to => 'sites#quick_lunch', :as => :quick_lunch
  get '/under_construction', :to => 'template_themes#under_construction', :as => :under_construction
  post '/create_admin_session', :to => 'template_themes#create_admin_session', :as => :create_admin_session

end
