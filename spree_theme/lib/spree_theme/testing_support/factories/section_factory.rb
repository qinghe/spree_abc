FactoryGirl.define do
  factory :section, class: Spree::Section do
    title 'a section'
    association :section_piece, factory: :section_piece

  end

  factory :section_container, class: Spree::Section do
    title 'a container section'
    association :section_piece, factory: :section_piece_container

    # section_container - section-child
    factory :section_with_children do
      after(:create) do |section, evaluator|
        create_list(:section, 1, parent: section, root_id: section.id)
        section.root_id = section.id
        section.save
      end
    end
  end

  factory :section_root, class: Spree::Section do
    title 'a root section'
    association :section_piece, factory: :section_piece_root
    after(:create) do |s, evaluator|
      s.root_id = s.id
      s.save
    end
  end
end
