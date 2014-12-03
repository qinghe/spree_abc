module Spree
  class CommentsController < StoreController
    before_filter :initialize_comment, :only => [:create, :new_to_site]
    
    def new_to_site
      @comment.commentable = Spree::Site.current
    end
  
    def create
      @comment.attributes =  object_params    
      if @comment.save
        flash[:success] = Spree.t(:comment_successfully_created, :scope=>@comment.comment_scope)
        respond_with(@comment) do |format|
          format.html { redirect_to :back }
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