namespace :spree_china_checkout do
  desc "load china addresses, include provice/city/district"
  task :reload_countries  => :environment do
    seed_path =  File.join(SpreeChinaCheckout::Engine.root,'db', 'seeds', 'countries.rb')
    load seed_path
  end
end
