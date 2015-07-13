Factory.define :site do |f|
  f.name "Site Name"
  f.domain "localhost"
end

Factory.define :product do |f|
 f.name "Product Name"
 f.description "Description"
 f.price 100
 f.count_on_hand 1
end
