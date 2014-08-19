#encoding: utf-8
module Spree
  UsersController.class_eval do
    respond_to :html, :js, :json
     # since redirect_to work in ajax, do not need rewrite 'update'
     
    def update
      if @user.update_attributes(params[:user])
        if params[:user][:password].present?
          # this logic needed b/c devise wants to log us out after password changes
          user = Spree::User.reset_password_by_token(params[:user])
          sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
        end
        if request.xhr?
          render "spree/shared/close_dialog"
        else
          redirect_to spree.account_url, :notice => Spree.t(:account_updated)            
        end
      else
        render :edit
      end
    end
    
    def check_email
      @user = Spree::User.new(params[:user] )
      @user.valid?
      result = ((!!@user.errors.include?(:email))== false)
      render :text=> result.to_json
    end
  end
end