require "spec_helper"

describe Spree::CommentsController, :type => :controller do
  describe "GET #index" do

    it "create comment" do
      comment_params = {"commentable_id"=>"1", "commentable_type"=>"Spree::Site", "comment"=>"this is my advice", "cellphone"=>"", "email"=>""}
      spree_xhr_post :create,comment_params
      expect(response).to be_success
      assigns(:comment).should be_persisted
    end

  end
end
