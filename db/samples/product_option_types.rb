#encoding: utf-8
#Spree::Sample.load_sample("products")

size = Spree::OptionType.find_by_presentation!("Size")
color = Spree::OptionType.find_by_presentation!("Color")

ror_baseball_jersey = Spree::Product.find_by_name!("代德杯子")
ror_baseball_jersey.option_types = [size, color]
ror_baseball_jersey.save!

spree_baseball_jersey = Spree::Product.find_by_name!("斯德哥尔摩意式咖啡杯")
spree_baseball_jersey.option_types = [size, color]
spree_baseball_jersey.save!
