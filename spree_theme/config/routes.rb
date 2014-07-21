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
    resources :template_texts
    resources :template_files
    resources :template_themes do
      collection do
        get :native
        get :foreign
      end
      member do
        get :config_resource   # assign resource(menu, image)
        get :config_context    # 
        get :config_data_source#    
        get :prepare_import    # assign resource(menu, image)
        post :copy
        post :release
        post :import
        post :apply
        
      end
      resources :page_layout do
        member do
          get :config_resource
          post :update_resource
          post :update_context
          post :update_data_source
        end
      end
    end
  end
  #namespace :api, :defaults => { :format => 'json' } do
  #  resources :template_themes do
  #    resources :page_layout do
  #    end
  #  end    
  #end
  
  get '/under_construction', :to => 'template_themes#under_construction', :as => :under_construction
  post '/create_admin_session', :to => 'template_themes#create_admin_session', :as => :create_admin_session
  get '/new_admin_session', :to => 'template_themes#new_admin_session', :as => :new_admin_session
  post '/check_email', :to => 'users#check_email', :as => :check_email

end
