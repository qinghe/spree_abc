FactoryGirl.define do
  factory :site_demo, class: Spree::Site do
    name 'demo1'
    email 'demo1@dalianshops.com'
    password 'password'
  end
  factory :site_demo2, class: Spree::Site do
    name 'demo2'
    email 'demo2@dalianshops.com'
    password 'password'
  end
end
