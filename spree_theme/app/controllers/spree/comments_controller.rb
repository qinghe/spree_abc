module Spree
  class CommentsController < StoreController
    before_filter :initialize_comment, :only => [:create, :new_to_site]
    
    def new_to_site
      
    end
  
    def create
      @comment.attributes =  object_params    
      if @comment.save
        flash[:success] = flash_message_for(@comment, :successfully_created)
        respond_with(@comment) do |format|
          format.js   { render :layout => false }
        end
      else
        respond_with(@comment)
      end
    end
  
    private
    
    def initialize_comment
      @comment = Comment.new(  )
      @comment.user = try_spree_current_user
      @comment.user ||= Spree.user_class.new
    end
     
    # comment{commentable_id, commentable_type, user_email}
    def object_params
      comment_params = params[:comment] 
      #user_email = comment_params.delete( :user_email )
      #if user_email
      #  user = User.find_or_initialize_by_email( user_email )
      #  if user.persited?
      #    comment_params[:user_id] = user.id
      #  else
      #    comment_params[:user] = user
      #  end
      #end
      comment_params
    end  
  end
  
end