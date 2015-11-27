require 'spec_helper'

describe Spree::UserTerminal do
  let (:user_terminal) { create :user_terminal }
  let (:template_theme) { create :template_theme }
  #@#let (:payment_method) { create :payment_method }

  before(:each){
    SpreeTheme.site_class.current = create(:fake_site)
  }

  it "should has valid association" do
    template_theme.user_terminal
  end
end
