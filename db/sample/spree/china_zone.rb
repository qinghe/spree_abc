#encoding: utf-8
#should not use name zones.yml, it would remove spree/core/db/spree/default/zones.yml 

zone = {
  :name=> 'China',
  :description => 'China mainland.'
}
china =  Spree::Country.find_by_name("China")
zone_member = Spree::ZoneMember.new(:zoneable => china)
china_zone = Spree::Zone.new(zone)
china_zone.zone_members << zone_member
china_zone.save!

#add provinces to country china
provinces = [ 
  { :name=> '北京', :abbr=> 'BJ'},
  { :name=> '辽宁', :abbr=> 'LN'},
  { :name=> '上海', :abbr=> 'SH'}
]
# china.states << provinces cause NameError: uninitialized constant State
# seems rails bug
provinces.each{| province| china.states.create province } 