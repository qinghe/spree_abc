require 'spec_helper'
describe Spree::ThemeConfiguration, "#site_class" do
  let (:config) { SpreeTheme }
  it "has website class" do

    expect(config.site_class).to be_a_kind_of(Class)
    expect(config.site_class.current).to be_an_instance_of(Spree::FakeWebsite)
  end
end