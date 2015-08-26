#encoding: utf-8
require 'rails_helper'
describe Spree::TemplateText do
  let!(:template_text) { create(:template_text) }

  it "should not create new template file" do
    expect{  described_class.find_or_copy( template_text ) }.to change{  described_class.count}.by(0)
  end

  context " current site is demo" do
    before( :each ) do
      Spree::Site.current = create(:site_demo2)
    end
    it "should create new template file" do
      expect{ described_class.find_or_copy( template_text ) }.to change{ described_class.count}.by(1)
    end
  end
end
