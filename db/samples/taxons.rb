#encoding: utf-8
#Spree::Sample.load_sample("taxonomies")
#Spree::Sample.load_sample("products")

categories = Spree::Taxonomy.find_by_name!("Categories")
brands = Spree::Taxonomy.find_by_name!("Brand")

products = { 
  :ror_tote => "加维克台灯",
  :ror_bag => "卡秋塔台灯",
  :ror_mug => "布朗达布兰科上菜用碗",
  :ror_stein => "巴尔巴托盘",
  :ror_baseball_jersey => "代德杯子",
  :ror_jr_spaghetti => "奥米欧茶壶",
  :ror_ringer => "莱思比茶杯",
  :spree_stein => "弗斯拉碗",
  :spree_mug => "奥芬利托盘",
  :spree_ringer => "昂顿大杯",
  :spree_baseball_jersey =>  "斯德哥尔摩意式咖啡杯",
  :spree_tote => "维迪亚台灯",
  :spree_bag => "克劳比工作灯",
  :spree_jr_spaghetti => "沃格特茶滤",
  :apache_baseball_jersey => "盖尔杯碟",
  :ruby_baseball_jersey => "哈里大杯", #Ruby Baseball Jersey
}


products.each do |key, name|
  products[key] = Spree::Product.find_by_name!(name)
end

taxons = [
  {
    :name => "Categories",
    :taxonomy => categories,
    :position => 0
  },
  {
    :name => "Bags",
    :taxonomy => categories,
    :parent => "Categories",
    :position => 1,
    :products => [
      products[:ror_tote],
      products[:ror_bag],
      products[:spree_tote],
      products[:spree_bag]
    ]
  },
  {
    :name => "Mugs",
    :taxonomy => categories,
    :parent => "Categories",
    :position => 2,
    :products => [
      products[:ror_mug],
      products[:ror_stein],
      products[:spree_stein],
      products[:spree_mug]
    ]
  },
  {
    :name => "Clothing",
    :taxonomy => categories,
    :parent => "Categories" 
  },
  {
    :name => "Shirts",
    :taxonomy => categories,
    :parent => "Clothing",
    :position => 0,
    :products => [
      products[:ror_jr_spaghetti],
      products[:spree_jr_spaghetti]
    ]
  },
  {
    :name => "T-Shirts",
    :taxonomy => categories,
    :parent => "Clothing" ,
    :products => [
      products[:ror_baseball_jersey],
      products[:ror_ringer],
      products[:apache_baseball_jersey],
      products[:ruby_baseball_jersey],
      products[:spree_baseball_jersey],
      products[:spree_ringer]
    ],
    :position => 0
  },
  {
    :name => "Brands",
    :taxonomy => brands
  },
  {
    :name => "Ruby",
    :taxonomy => brands,
    :parent => "Brand" 
  },
  {
    :name => "Apache",
    :taxonomy => brands,
    :parent => "Brand" 
  },
  {
    :name => "Spree",
    :taxonomy => brands,
    :parent => "Brand"
  },
  {
    :name => "Rails",
    :taxonomy => brands,
    :parent => "Brand"
  },
]

taxons.each do |taxon_attrs|
  if taxon_attrs[:parent]
    taxon_attrs[:parent] = Spree::Taxon.find_by_name!(taxon_attrs[:parent])
    Spree::Taxon.create!(taxon_attrs, :without_protection => true)
  end
end
