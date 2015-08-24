FactoryGirl.define do
  factory :param_value_block, class: Spree::ParamValue do
    pvalue { {'21'=> 'width:200px', '21unset'=> false} }

    association :section_param, factory: :section_param_block
  end

  factory :section_param_block, class: Spree::SectionParam do
    association :section, factory: :section_block
  end

  factory :section_block, class: Spree::Section do

  end

end
