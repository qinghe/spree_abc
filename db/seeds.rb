# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# notice loading order,  site, default data, user

ENV['AUTO_ACCEPT'] ='1'

load File.dirname(__FILE__)+ "/default/seed.rb"


SpreeTheme::Engine.load_seed
# fake_orders/spree/*  are data related to orders, like address, order..
# for reasons time consume and useless to customer, system does not load those file while loading sample.
# it is only for test now.
load File.dirname(__FILE__)+ "/shopfirst/seed.rb"
load File.dirname(__FILE__)+ "/shopdesign/seed.rb"
load File.dirname(__FILE__)+ "/shopdemo/seed.rb"
load File.dirname(__FILE__)+ "/patch/seed.rb"

