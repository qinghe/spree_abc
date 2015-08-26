FactoryGirl.define do

  factory :taxon_for_duplicator, class: Spree::Taxon do
    name 'taxon for duplicator'
    taxonomy
    after(:create) do |taxon, evaluator|
      create_list( :taxon_node, 5, parent: taxon)
    end
  end

  factory :taxon_node, class: Spree::Taxon do
    name 'taxon node'
  end

end
