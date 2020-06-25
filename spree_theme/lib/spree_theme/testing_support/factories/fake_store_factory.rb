FactoryGirl.define do
  factory :fake_site, class: Spree::FakeWebsite do
    name 'Fake site'
  end

  factory :themed_store, class: Spree::Store do
    sequence(:code) { |i| "spree_#{i}" }
    name 'Spree Test Store'
    url 'www.example.com'
    mail_from_address 'spree@example.org'
    theme_id 0
  end
end
