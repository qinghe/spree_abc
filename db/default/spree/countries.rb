#encoding: utf-8
Spree::Country.create!({"name"=>"中国", "iso3"=>"CHN", "iso"=>"CN", "iso_name"=>"CHINA", "numcode"=>"156"})
country =  Spree::Country.find_by_iso("CN")
Spree::Config[:default_country_id] = country.id
# load states.yml, cities.yml

states = YAML::load(File.read( File.join(File.dirname(__FILE__),'states.yml')))
states.each_pair{|key,state|  
  Spree::State.create!({"name"=>state["name"], "abbr"=>state["abbr"], :country=>country})
}

cities = YAML::load(File.read( File.join(File.dirname(__FILE__),'cities.yml'))) 
Spree::State.all.each{|state|
  cities.select{|key,city|
    city['state']==state.name
  }.each_pair{|key, city|
    Spree::City.create!({"name"=>city["name"], "abbr"=>city["abbr"], :state=>state})
  }
}



