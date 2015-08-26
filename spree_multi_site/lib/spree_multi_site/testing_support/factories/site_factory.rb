FactoryGirl.define do
  factory :site_demo, class: Spree::Site do
    name 'demo1'
    email 'demo1@dalianshops.com'
    password 'password'
    before(:create) do
      Spree::Role.find_by(name: 'admin') || create(:role, name: 'admin')
    end
    factory :site_demo2 do
      name 'demo2'
      email 'demo2@dalianshops.com'
    end
    
  end

end
