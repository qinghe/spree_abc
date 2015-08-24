FactoryGirl.define do
  factory :param_value, class: Spree::ParamValue do
    pvalue { {'21'=> 'width:200px', '21unset'=> false} }

    association :section_param, factory: :section_param
  end





end
