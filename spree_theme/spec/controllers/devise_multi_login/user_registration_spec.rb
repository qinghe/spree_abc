require "spec_helper"
# login with email/cellphone

# sign up with email/cellphone

#   sign up with existing email/cellphone

# edit  email/cellphone
#devise_scope :spree_user do
#  get '/login' => 'user_sessions#new', :as => :login
#  post '/login' => 'user_sessions#create', :as => :create_new_session
#  get '/logout' => 'user_sessions#destroy', :as => :logout
#  get '/signup' => 'user_registrations#new', :as => :signup
#  post '/signup' => 'user_registrations#create', :as => :registration
#  get '/password/recover' => 'user_passwords#new', :as => :recover_password
#  post '/password/recover' => 'user_passwords#create', :as => :reset_password
#  get '/password/change' => 'user_passwords#edit', :as => :edit_password
#  put '/password/change' => 'user_passwords#update', :as => :update_password
#  get '/confirm' => 'user_confirmations#show', :as => :confirmation if Spree::Auth::Config[:confirmable]
#end
RSpec.describe Spree::UserRegistrationsController, type: :controller do

  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context '#create' do
    stub_initialize_template!

    before { allow(controller).to receive(:after_sign_up_path_for).and_return(spree.root_path(thing: 7)) }

    it 'redirects to after_sign_up_path_for' do
      spree_post :create, { spree_user: { cellphone: '13012345678', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(response).to redirect_to spree.root_path(thing: 7)
    end
  end
end
