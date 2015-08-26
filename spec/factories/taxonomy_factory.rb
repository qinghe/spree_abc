FactoryGirl.define do

  factory :taxon_for_duplicator, class: Spree::Taxon do
    name 'taxon for duplicator'
    parent_id nil
    taxonomy
    after(:create) do |taxon, evaluator|
      create_list( :taxon_node, 3, parent: taxon)
      taxon.reload #it is required, or lft,rgt incorrect
    end
  end

  factory :taxon_node, class: Spree::Taxon do
    name 'taxon node'
  end

end
