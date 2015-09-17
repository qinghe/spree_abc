FactoryGirl.define do
  factory :section, class: Spree::Section do
    association :section_piece, factory: :section_piece
    after(:create) do |s, evaluator|
      s.root_id = s.id
      s.save
    end
  end

  factory :section_container, class: Spree::Section do
    association :section_piece, factory: :section_piece_container

    factory :section_with_children do
      after(:create) do |section, evaluator|
        create_list(:section, 1, parent: section, root_id: section.id)
        section.root_id = section.id
        section.save
      end
    end
  end

  factory :section_root, class: Spree::Section do
    association :section_piece, factory: :section_piece_root
  end
end
