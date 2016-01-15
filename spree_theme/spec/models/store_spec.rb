require 'spec_helper'
describe Spree::Store do
  let (:template) { create :template_theme }
  before (:each){
    create(:store, default: true)
  }
  it "should be applied" do
    Spree::Store.current.apply_theme( template )
    template.applied?.should be_truthy
  end
end
