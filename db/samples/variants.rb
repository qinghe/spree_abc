#encoding: utf-8
#Spree::Sample.load_sample("option_values")
#Spree::Sample.load_sample("products")

ror_baseball_jersey = Spree::Product.find_by_name!("代德杯子")
ror_tote = Spree::Product.find_by_name!("加维克台灯")
ror_bag = Spree::Product.find_by_name!("卡秋塔台灯")
ror_jr_spaghetti = Spree::Product.find_by_name!("奥米欧茶壶")
ror_mug = Spree::Product.find_by_name!("布朗达布兰科上菜用碗")
ror_ringer = Spree::Product.find_by_name!("莱思比茶杯")
ror_stein = Spree::Product.find_by_name!("巴尔巴托盘")
spree_baseball_jersey = Spree::Product.find_by_name!("斯德哥尔摩意式咖啡杯")
spree_stein = Spree::Product.find_by_name!("弗斯拉碗") 
spree_jr_spaghetti = Spree::Product.find_by_name!("沃格特茶滤")
spree_mug = Spree::Product.find_by_name!("奥芬利托盘")
spree_ringer = Spree::Product.find_by_name!("昂顿大杯")
spree_tote = Spree::Product.find_by_name!("维迪亚台灯")
spree_bag = Spree::Product.find_by_name!("克劳比工作灯") 
ruby_baseball_jersey = Spree::Product.find_by_name!("哈里大杯")
apache_baseball_jersey = Spree::Product.find_by_name!("盖尔杯碟")

#OptionValue have not site_id, we should never use OptionValue.find..
small = Spree::OptionType.find_by_presentation!("Size").option_values.find_by_name!("Small")
medium = Spree::OptionType.find_by_presentation!("Size").option_values.find_by_name!("Medium")
large = Spree::OptionType.find_by_presentation!("Size").option_values.find_by_name!("Large")
extra_large = Spree::OptionType.find_by_presentation!("Size").option_values.find_by_name!("Extra Large")

red = Spree::OptionType.find_by_presentation!("Color").option_values.find_by_name!("Red")
blue = Spree::OptionType.find_by_presentation!("Color").option_values.find_by_name!("Blue")
green = Spree::OptionType.find_by_presentation!("Color").option_values.find_by_name!("Green")

variants = [
  {
    :product => ror_baseball_jersey,
    :option_values => [small, red],
    :sku => "ROR-00001",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [small, blue],
    :sku => "ROR-00002",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [small, green],
    :sku => "ROR-00003",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [medium, red],
    :sku => "ROR-00004",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [medium, blue],
    :sku => "ROR-00005",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [medium, green],
    :sku => "ROR-00006",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [large, red],
    :sku => "ROR-00007",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [large, blue],
    :sku => "ROR-00008",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [large, green],
    :sku => "ROR-00009",
    :cost_price => 17
  },
  {
    :product => ror_baseball_jersey,
    :option_values => [extra_large, green],
    :sku => "ROR-00012",
    :cost_price => 17
  },
]

masters = {
  ror_baseball_jersey => {
    :sku => "ROR-001",
    :cost_price => 17,
  },
  ror_tote => {
    :sku => "ROR-00011",
    :cost_price => 17
  },
  ror_bag => {
    :sku => "ROR-00012",
    :cost_price => 21
  },
  ror_jr_spaghetti => {
    :sku => "ROR-00013",
    :cost_price => 17
  },
  ror_mug => {
    :sku => "ROR-00014",
    :cost_price => 11
  },
  ror_ringer => {
    :sku => "ROR-00015",
    :cost_price => 17
  },
  ror_stein => {
    :sku => "ROR-00016",
    :cost_price => 15
  },
  apache_baseball_jersey => {
    :sku => "APC-00001",
    :cost_price => 17
  },
  ruby_baseball_jersey => {
    :sku => "RUB-00001",
    :cost_price => 17
  },
  spree_baseball_jersey => {
    :sku => "SPR-00001",
    :cost_price => 17
  },
  spree_stein => {
    :sku => "SPR-00016",
    :cost_price => 15
  },
  spree_jr_spaghetti => {
    :sku => "SPR-00013",
    :cost_price => 17
  },
  spree_mug => {
    :sku => "SPR-00014",
    :cost_price => 11
  },
  spree_ringer => {
    :sku => "SPR-00015",
    :cost_price => 17
  },
  spree_tote => {
    :sku => "SPR-00011",
    :cost_price => 13
  },
  spree_bag => {
    :sku => "SPR-00012",
    :cost_price => 21
  }
}

variants.each do |variant_attrs|
  Spree::Variant.create!(variant_attrs, :without_protection => true)
end

masters.each do |product, variant_attrs|
  product.master.update_attributes!(variant_attrs)
end
