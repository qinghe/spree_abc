FactoryGirl.define do
  factory :site1, class: Spree::Site do
    name 'first'
    email 'first@dalianshops.com'
    password 'password'

    before(:create) do
      Spree::Role.find_by(name: 'admin') || create(:role, name: 'admin')
    end

    after(:create) do| site |
      create(:store, site: site )
    end

    factory :site2 do
      name 'design'
      email 'design@dalianshops.com'
    end

  end

end