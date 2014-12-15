#encoding: utf-8
#Spree::Sample.load_sample("products")
#Spree::Sample.load_sample("variants")

products = {}
products[:ror_baseball_jersey] = Spree::Product.find_by_name!("代德杯子") 
products[:ror_tote] = Spree::Product.find_by_name!("加维克台灯") 
products[:ror_bag] = Spree::Product.find_by_name!("卡秋塔台灯") 
products[:ror_jr_spaghetti] = Spree::Product.find_by_name!("奥米欧茶壶")
products[:ror_mug] = Spree::Product.find_by_name!("布朗达布兰科上菜用碗")
products[:ror_ringer] = Spree::Product.find_by_name!("莱思比茶杯")
products[:ror_stein] = Spree::Product.find_by_name!("巴尔巴托盘")
products[:spree_baseball_jersey] = Spree::Product.find_by_name!("斯德哥尔摩意式咖啡杯")
products[:spree_stein] = Spree::Product.find_by_name!("弗斯拉碗")
products[:spree_jr_spaghetti] = Spree::Product.find_by_name!("沃格特茶滤")
products[:spree_mug] = Spree::Product.find_by_name!("奥芬利托盘")
products[:spree_ringer] = Spree::Product.find_by_name!("昂顿大杯")
products[:spree_tote] = Spree::Product.find_by_name!("维迪亚台灯")
products[:spree_bag] = Spree::Product.find_by_name!("克劳比工作灯")
products[:ruby_baseball_jersey] = Spree::Product.find_by_name!("哈里大杯")
products[:apache_baseball_jersey] = Spree::Product.find_by_name!("盖尔杯碟")


def image(name, type="jpeg")
  images_path = Pathname.new(File.dirname(__FILE__)) + "images"
  path = images_path + "#{name}.#{type}"
  return false if !File.exist?(path)
  File.open(path)
end

images = {
  products[:ror_tote].master => [
    {
      :attachment => image("ror_tote")
    },
    {
      :attachment => image("ror_tote_back") 
    }
  ],
  products[:ror_bag].master => [
    {
      :attachment => image("ror_bag")
    }
  ],
  products[:ror_baseball_jersey].master => [
    {
      :attachment => image("ror_baseball")
    },
    {
      :attachment => image("ror_baseball_back")
    }
  ],
  products[:ror_jr_spaghetti].master => [
    {
      :attachment => image("ror_jr_spaghetti")
    }
  ],
  products[:ror_mug].master => [
    {
      :attachment => image("ror_mug")
    },
    {
      :attachment => image("ror_mug_back")
    }
  ],
  products[:ror_ringer].master => [
    {
      :attachment => image("ror_ringer")
    },
    {
      :attachment => image("ror_ringer_back")
    }
  ],
  products[:ror_stein].master => [
    {
      :attachment => image("ror_stein")
    },
    {
      :attachment => image("ror_stein_back")
    }
  ],
  products[:apache_baseball_jersey].master => [
    {
      :attachment => image("apache_baseball")
    },
  ],
  products[:ruby_baseball_jersey].master => [
    {
      :attachment => image("ruby_baseball")
    },
  ],
  products[:spree_bag].master => [
    {
      :attachment => image("spree_bag")
    },
  ],
  products[:spree_tote].master => [
    {
      :attachment => image("spree_tote_front")
    },
    {
      :attachment => image("spree_tote_back") 
    }
  ],
  products[:spree_ringer].master => [
    {
      :attachment => image("spree_ringer_t")
    },
    {
      :attachment => image("spree_ringer_t_back") 
    }
  ],
  products[:spree_jr_spaghetti].master => [
    {
      :attachment => image("spree_spaghetti")
    }
  ],
  products[:spree_baseball_jersey].master => [
    {
      :attachment => image("spree_jersey")
    },
    {
      :attachment => image("spree_jersey_back") 
    }
  ],
  products[:spree_stein].master => [
    {
      :attachment => image("spree_stein")
    },
    {
      :attachment => image("spree_stein_back") 
    }
  ],
  products[:spree_mug].master => [
    {
      :attachment => image("spree_mug")
    },
    {
      :attachment => image("spree_mug_back") 
    }
  ],
}

products[:ror_baseball_jersey].variants.each do |variant|
  color = variant.option_value("tshirt-color").downcase
  main_image = image("ror_baseball_jersey_#{color}")
  variant.images.create!(:attachment => main_image)
  back_image = image("ror_baseball_jersey_back_#{color}")
  if back_image
    variant.images.create!(:attachment => back_image)
  end
end

images.each do |variant, attachments|
  puts "Loading images for #{variant.name}"
  attachments.each do |attachment|
    variant.images.create!(attachment)
  end
end

