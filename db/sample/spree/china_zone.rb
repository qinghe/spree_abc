#encoding: utf-8
#should not use name zones.yml, it would remove spree/core/db/spree/default/zones.yml 

china =  Spree::Country.find_by_name("China")
zone_member = Spree::ZoneMember.new(:zoneable => china)
china_zone = Spree::Zone.find_by_name("China")
china_zone.zone_members << zone_member
china_zone.save!

