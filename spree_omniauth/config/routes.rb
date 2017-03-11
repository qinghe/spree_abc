Spree::Core::Engine.routes.draw do
  namespace :open do
    resource :wechat, only: [:show, :create] do
      get "callback"
    end
  end

  # Add your extension routes here
  # get "/auth/:provider/callback" => "sessions#create"

  get "/open/wechat/callback" => "wechats#callback"

end
