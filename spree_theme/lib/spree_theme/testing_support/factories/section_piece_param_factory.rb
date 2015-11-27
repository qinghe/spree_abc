FactoryGirl.define do
  factory :section_piece_param, class: Spree::SectionPieceParam do
    association :section_piece, factory: :section_piece
    association :editor, factory: :editor
    association :param_category, factory: :param_category
  end

  factory :editor, class: Spree::Editor do
  end

  factory :param_category, class: Spree::ParamCategory do
  end
end
