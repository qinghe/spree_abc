require 'rails_helper'
describe Spree::User do

  let( :valid_cellphone ) { '13012345678' }
  let(:new_user){ build(:user) }

  before(:each) do
    Spree::Site.current = create(:site1)
  end

  context "use email as login" do
    it "should create user without cellphone" do
      user = new_user
      user.cellphone = nil
      expect{  user.save }.to change{  described_class.count}.by(1)
    end

  end

  context "use cellphone as login" do
    it "should create user without email" do
      user = new_user
      user.cellphone = valid_cellphone
      user.email = nil
      expect{  user.save }.to change{  described_class.count}.by(1)
    end
  end

  it "should not create new template file" do
    #http://baike.baidu.com/view/58286.htm
    #13[0-9]
    #14[4,7]
    #15[0-9]
    #17[0]
    #18[0-9]
    #'13000000000' # 11
    #invalid_cellphone = '1300000000'  # 10
    #'130000000000'# 12
    #user.cellphone =
    #expect{  described_class.find_or_copy( @template_text ) }.to change{  described_class.count}.by(0)
  end


end
