FactoryGirl.define do
  factory :page_layout, class: Spree::PageLayout do
    title 'page layout'
  end

  factory :page_layout_tree, class: Spree::PageLayout do
    title 'page layout tree'
    association :section, factory: :section_root

    after(:create) do |pl, evaluator|
      pl.root_id = pl.id
      pl.save
      create( :page_layout_node, parent: pl, root_id: pl.id)
    end

  end

  factory :page_layout_node, class: Spree::PageLayout do
    association :section, factory: :section
    title 'page layout node'
  end

end
