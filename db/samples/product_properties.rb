#encoding: utf-8
products =
  { 
    "代德杯子" => #Ruby on Rails Baseball Jersey 
    { 
      "Manufacturer" => "Wilson",
      "Brand" => "Wannabe Sports",
      "Model" => "JK1002",
      "Shirt Type" => "Baseball Jersey",
      "Sleeve Type" => "Long",
      "Made from" => "100% cotton",
      "Fit" => "Loose",
      "Gender" => "Men's"
    },
    "奥米欧茶壶" => #Ruby on Rails Jr. Spaghetti
    {
      "Manufacturer" => "Jerseys",
      "Brand" => "Resiliance",
      "Model" => "TL174",
      "Shirt Type" => "Jr. Spaghetti T",
      "Sleeve Type" => "None",
      "Made from" => "90% Cotton, 10% Nylon",
      "Fit" => "Form",
      "Gender" => "Women's"
    },
    "莱思比茶杯" =>
    {
      "Manufacturer" => "Jerseys",
      "Brand" => "Conditioned",
      "Model" => "TL9002",
      "Shirt Type" => "Ringer T",
      "Sleeve Type" => "Short",
      "Made from" => "100% Vellum",
      "Fit" => "Loose",
      "Gender" => "Men's"
    },
    "加维克台灯" => #ror_tote
    {
      "Type" => "Tote",
      "Size" => %Q{15" x 18" x 6"},
      "Material" => "Canvas"
    },
    "卡秋塔台灯" => # ror_bag
    {
      "Type" => "Messenger",
      "Size" => %Q{14 1/2" x 12" x 5"},
      "Material" => "600 Denier Polyester"
    },
    "布朗达布兰科上菜用碗" => #ror_mug 
    {
      "Type" => "Mug",
      "Size" => %Q{4.5" tall, 3.25" dia.}
    },
    "巴尔巴托盘" => #ror_stein
    {
      "Type" => "Stein",
      "Size" => %Q{6.75" tall, 3.75" dia. base, 3" dia. rim}
    },
    "弗斯拉碗" => #Spree Stein
    {
      "Type" => "Stein",
      "Size" => %Q{6.75" tall, 3.75" dia. base, 3" dia. rim}
    },
    "奥芬利托盘" => #Spree Mug 
    {
      "Type" => "Mug",
      "Size" => %Q{4.5" tall, 3.25" dia.}
    },
    "维迪亚台灯" => #Spree Tote 
    {
      "Type" => "Tote",
      "Size" => %Q{15" x 18" x 6"}
    },
    "克劳比工作灯" => 
    {
      "Type" => "Messenger",
      "Size" => %Q{14 1/2" x 12" x 5"}
    },
    "斯德哥尔摩意式咖啡杯" => #Spree Baseball Jersey
    {
      "Manufacturer" => "Wilson",
      "Brand" => "Wannabe Sports",
      "Model" => "JK1002",
      "Shirt Type" => "Baseball Jersey",
      "Sleeve Type" => "Long",
      "Made from" => "100% cotton",
      "Fit" => "Loose",
      "Gender" => "Men's"
    },
    "沃格特茶滤" =>
    {
      "Manufacturer" => "Jerseys",
      "Brand" => "Resiliance",
      "Model" => "TL174",
      "Shirt Type" => "Jr. Spaghetti T",
      "Sleeve Type" => "None",
      "Made from" => "90% Cotton, 10% Nylon",
      "Fit" => "Form",
      "Gender" => "Women's"
    },
    "昂顿大杯" => #Spree Ringer T-Shirt
    {
      "Manufacturer" => "Jerseys",
      "Brand" => "Conditioned",
      "Model" => "TL9002",
      "Shirt Type" => "Ringer T",
      "Sleeve Type" => "Short",
      "Made from" => "100% Vellum",
      "Fit" => "Loose",
      "Gender" => "Men's"
    },
  }

products.each do |name, properties|
  product = Spree::Product.find_by_name(name)
  properties.each do |prop_name, prop_value|
    product.set_property(prop_name, prop_value)
  end
end
