require "spec_helper"

describe Spree::CommentsController, :type => :controller do
  describe "GET #index" do
    stub_initialize_template!
    it "create comment" do
      comment_params ={ :comment=> {"commentable_id"=>"1", "commentable_type"=>"Spree::Store", "comment"=>"this is my advice", "cellphone"=>"", "email"=>""} }
      xhr_post :create,comment_params
      expect(response).to be_success
      assigns(:comment).should be_persisted
    end

  end
end
