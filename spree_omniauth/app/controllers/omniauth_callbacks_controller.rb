class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  def callback
  # 1. 寻找用户 uid + provider
  # 2. 如果他没有那么创造和记录用户在O _码数据
  # 3. 为用户创造 session
     auth = request.env['rack.auth']
     user = Spree::User.find_by_provider_and_uid(auth['provider'],auth['uid'])
     if user.nil?
       user = Spree::User.create_by_auth(auth)
     end
     @user_session = UserSession.new(user)
     puts @user_session.save!
     if @user_session
       redirect_to '/', :notice => "Welcome, #{auth['user_info']['name']}"
     else
       redirect_to '/login', :alert => "Error login"
     end
  end
end
