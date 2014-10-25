require 'spec_helper'
describe Spree::TemplateText do

  
  it "should copy" do
    Spree::Site.current = Spree::Site.find 2
    
    text = Spree::TemplateText.create!( :name=>"惟一用途",:body=>"内容")
    Spree::Site.current = Spree::Site.find 1
    new_text = Spree::TemplateText.find_or_copy text
    new_text.reload
    new_text.site.should eq Spree::Site.current
    new_text.name.should eq text.name
    new_text.body.should eq text.body
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
