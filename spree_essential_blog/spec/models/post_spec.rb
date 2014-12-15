#encoding: utf-8
require 'spec_helper'
describe Spree::Post do
  let(:post) { FactoryGirl.build(:post) }

  
  
  it "new post" do
    post.title = "中文标题"
    post.should be_valid
    post.permalink.should be_present
  end
  
end
