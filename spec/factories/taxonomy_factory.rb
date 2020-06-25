FactoryGirl.define do

  factory :taxon_for_duplicator, class: Spree::Taxon do
    name 'taxon for duplicator'
    parent_id nil
    taxonomy
    after(:create) do |taxon, evaluator|
      # root  ( count 12)
      #  -node 1
      #  -node 2
      #    -node 21
      #    -node 22
      #  -node 3
      #    -node 31
      #    -node 32
      #  -node 4
      #    -node 41
      #      -node 411
      #      -node 412
      create( :taxon_node, parent: taxon )
      create( :taxon_node, parent: taxon, children:( build_list( :taxon_node, 2) ))
      create( :taxon_node, parent: taxon, children:( build_list( :taxon_node, 2) ))
      create( :taxon_node, parent: taxon, children:( build_list( :taxon_node, 1, children:( build_list( :taxon_node, 2) )) ))
      taxon.reload #it is required, or lft,rgt incorrect
    end
  end

  factory :taxon_node, class: Spree::Taxon do
    name 'taxon node'
  end

end
