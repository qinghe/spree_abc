Spree::Core::Engine.add_routes do

  root :to => 'template_themes#page'
  # Add your extension routes here
  resources :template_themes do
     member do
       get :preview # add function preview_template_theme_path
       post :get_param_values # to support post data>1024byte
       post :update_param_value
       post :update_layout_tree
       get  :upload_file_dialog
       post :upload_file_dialog
     end

     collection do
       #get :preview # add function preview_template_themes_path
     end

     resources :page_layouts, only: [:edit,:update] do

     end

  end

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

  resources :comments, :only=>[:create] do
    collection do
      get :new_to_site
    end
  end

  get '(/:c(/:r))' => 'template_themes#page' , :c => /\d[^\/]*/ # :c, taxon_id-friendly_id,  :r, product_id-friendly_id
  get '/post/:c/:p' => 'template_themes#page', :c => /\d[^\/]*/ #
  get '/preview/:id' => 'template_themes#preview' #preview template_theme, for design shop only.

  get '/under_construction', :to => 'template_themes#under_construction', :as => :under_construction
  post '/create_admin_session', :to => 'template_themes#create_admin_session', :as => :create_admin_session
  get '/new_admin_session', :to => 'template_themes#new_admin_session', :as => :new_admin_session
  post '/check_email', :to => 'users#check_email', :as => :check_email


  #api extension
  namespace :api, :defaults => { :format => 'json' } do
    resources :template_themes do
      member do
        get :jstree
      end
      resources :page_layouts do
        member do
          get :jstree
        end
      end
    end
    resources :taxons, :only => [:index] do
      collection do
       get :global
     end
    end
  end

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
        #get :prepare_import    # assign resource(menu, image)
        post :copy
        post :release
        patch :apply
      end

      resources :page_layouts do
        member do
          get :config_resource
          get :config_context
          get :config_data_source
          post :update_resource
          post :update_context
          post :update_data_source
        end
      end
    end
  end
end
