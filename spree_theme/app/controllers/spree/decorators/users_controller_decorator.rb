#encoding: utf-8
module Spree
  UsersController.class_eval do
    respond_to :html, :js, :json
     # since redirect_to work in ajax, do not need rewrite 'update'
     
    def update
      if @user.update_attributes(params.require(:user))
        if params[:user][:password].present?
          # this logic needed b/c devise wants to log us out after password changes
          user = Spree::User.reset_password_by_token(params[:user])
          sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
        end
        
        respond_with(@user) do |format|
          format.html { redirect_to spree.account_url, :notice => Spree.t(:account_updated) }
          format.js   { render :layout => false }
        end        
      else
        render :edit
      end
    end
    
    def check_email
      @user = Spree::User.new(params.require(:site) )
      @user.valid?
      result = ((!!@user.errors.include?(:email))== false)
      render :text=> result.to_json
    end
  end
end