module Spree
  module Api
    module V1
      class AuthController < Spree::Api::BaseController
        skip_before_action :authenticate_user
        skip_before_action :load_user
        skip_before_action :load_user_roles
        skip_before_action :authorize_for_order

        def sign_up
          @user = Spree.user_class.new(user_params)
          @user.generate_spree_api_key! unless @user.spree_api_key
          if @user.save
            respond_with(@user, status: 201, default_template: :sign_in)
          else
            invalid_resource!(@user)
          end
        end
        #curl -X POST -d 'user[email]=xxx@getstore.cn&user[password]=xxxxxx'  http://localhost:3000/api/v1/auth/sign_in
        def sign_in
          if @user = Spree.user_class.find_for_database_authentication(login: user_params[:email])
            if @user.valid_password? user_params[:password]

              @user.generate_spree_api_key! unless @user.spree_api_key
              # render 'spree/api/v1/auth/token'
              respond_with(@user)
            else
              # Wrong Password
              render json: {
                error: "Email or password invalid.",
                errors: {
                  password: ["incorrect"]
                }
              }, status: 422
            end
          else
            # User Not Found
            render json: {
              error: "Email or password invalid.",
              errors: {
                email: ["not found"]
              }
            }, status: 422
          end
        end

        # def facebook
        #   if params[:facebook_access_token]
        #     begin
        #       facebook_access_token = params[:facebook_access_token]
        #       graph = Koala::Facebook::API.new(facebook_access_token)
        #       profile = graph.get_object("me", fields:[:id, :name, :email])
        #       facebook_uid = profile["id"]
        #       api_user_authentication = Spree::ApiUserAuthentication.where(uid: facebook_uid, provider: 'facebook').first
        #       if !api_user_authentication
        #         email = profile["email"]
        #         if email.present? && Spree.user_class.where(email: email).exists?
        #           # email exists
        #           render json: {
        #             error: "Email already exists.",
        #             errors: {
        #               email: ["already exists"]
        #             }
        #           }, status: 422
        #         else
        #           if email.blank? then
        #             # temp hack
        #             email = "#{profile['id']}@nonexistentfbuseremail.com"
        #           end
        #           @user = Spree.user_class.create!(
        #             email: email,
        #             password: Devise.friendly_token.first(8)
        #           )
        #           @user.api_user_authentications.create!(provider: 'facebook', uid: facebook_uid)
        #         end
        #       else
        #         @user = Spree.user_class.find(api_user_authentication.user_id)
        #       end
        #       @user.generate_spree_api_key! unless @user.spree_api_key
        #       respond_with(@user, default_template: :sign_in)
        #     rescue Koala::Facebook::AuthenticationError => e
        #       # email exists
        #       render json: {
        #         error: "Facebook access token invalid.",
        #         errors: {
        #           facebook_access_token: ["Invalid"]
        #         }
        #       }, status: 422
        #     end
        #   end
        # end
        def user_params
          params.require(:user).permit(permitted_user_attributes |
                                         [bill_address_attributes: permitted_address_attributes,
                                          ship_address_attributes: permitted_address_attributes])
        end
      end
    end
  end
end
