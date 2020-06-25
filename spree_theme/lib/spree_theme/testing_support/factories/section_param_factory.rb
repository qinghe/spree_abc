FactoryGirl.define do

  factory :section_param, class: Spree::SectionParam do
    association :section, factory: :section
  end

end
