#encoding: utf-8
require 'rails_helper'
describe Spree::TemplateText do
  before(:each) do
    Spree::Site.current = create(:site1)
    @template_text =  create(:template_text)
  end
  it "should not create new template file" do
    expect{  described_class.find_or_copy( @template_text ) }.to change{  described_class.count}.by(0)
  end

  context "current site demo2" do
    before( :each ) do
      Spree::Site.current = create(:site2)
    end
    it "should create new template file" do
      expect{ described_class.find_or_copy( @template_text ) }.to change{ described_class.count}.by(1)
    end
  end
end
