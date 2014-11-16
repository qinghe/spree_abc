#encoding: utf-8
#should not use name zones.yml, it would remove spree/core/db/spree/default/zones.yml 
china = Spree::Zone.create!(:name => "中国", :description => "中国大陆.")


china =  Spree::Country.find_by_iso!("CN")
zone_member = Spree::ZoneMember.new(:zoneable => china)
china_zone = Spree::Zone.find_by_name("中国")
china_zone.zone_members << zone_member
china_zone.save!


