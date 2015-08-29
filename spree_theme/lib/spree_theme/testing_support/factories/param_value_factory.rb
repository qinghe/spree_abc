FactoryGirl.define do
  factory :param_value, class: Spree::ParamValue do
    pvalue { {'21'=> 'width:200px', '21unset'=> false} }

    template_theme
    association :section_param, factory: :section_param

    factory :updatable_param_value, class: Spree::ParamValue do
      # param_vlaue -> section_param -> section_piece_param
      after(:create) do|pv|
        spp = create(:section_piece_param)
        pv.section_param.update_attribute( :section_piece_param, spp )
      end
    end
  end





end
