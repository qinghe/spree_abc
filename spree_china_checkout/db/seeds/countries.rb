Spree::Country.connection.truncate :spree_countries
Spree::Country.connection.truncate :spree_states
Spree::Country.connection.truncate :spree_cities
Spree::Country.connection.truncate :spree_districts

Spree::Country.create!({"name"=>"中国", "iso3"=>"CHN", "iso"=>"CN", "iso_name"=>"CHINA", "numcode"=>"156"})
country =  Spree::Country.find_by_iso("CN")
#Spree::Config[:default_country_id] = country.id
# load states.yml, cities.yml

states = YAML::load(File.read( File.join(File.dirname(__FILE__),'states.yml')))
states.each_pair{|key,state|
  Spree::State.create!({id: state['id'], name: state["name"], abbr: state["abbr"], country: country})
}


path =  File.join(SpreeChinaCheckout::Engine.root,'db', 'seeds', 'areas.json')
json_string = File.read(path)
json = JSON.parse json_string

# add cities and districts for provice
Spree::State.all.each{|state|
  cities = json[state.name]
  raise "missing cities for provice #{ state.name} " unless cities.present?

  cities.each{ |city_name, districts|
    city = Spree::City.create!({ name: city_name, state: state})
    districts.each{|district|
      Spree::District.create!({ name: district, city: city})
    }
  }
}
