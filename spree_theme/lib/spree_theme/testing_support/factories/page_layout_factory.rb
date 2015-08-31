FactoryGirl.define do
  factory :page_layout, class: Spree::PageLayout do
    title 'page layout'
  end

  factory :page_layout_tree, class: Spree::PageLayout do
    title 'page layout tree'
    association :section, factory: :section_root
    after(:create) do |pl, evaluator|
      create( :page_layout_node, parent: pl)
    end
  end

  factory :page_layout_node, class: Spree::PageLayout do
    association :section, factory: :section
    title 'page layout node'
  end

  factory :page_layout_root, class: Spree::PageLayout do
    association :section, factory: :section_root
    title 'page layout root'
  end


end
