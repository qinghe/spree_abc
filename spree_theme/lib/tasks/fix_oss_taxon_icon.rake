require 'aliyun/oss'

def fix_oss_taxon_icon_sample
  client = Aliyun::OSS::Client.new(
  :endpoint => 'oss-cn-beijing.aliyuncs.com',
  :access_key_id => ENV["ALIYUN_OSS_ACCESS_ID"],
  :access_key_secret => ENV["ALIYUN_OSS_ACCESS_SECRET"])

  bucket = client.get_bucket('aliimg')
  object_key ='sample/980x260.jpg'
  if bucket.object_exists?(object_key)
    puts "key #{object_key} exists"
    bucket.copy_object( object_key,  'sample/980x260.jpg.bak')
  end
end

def fix_oss_taxon_icon
  client = Aliyun::OSS::Client.new(
  :endpoint => 'oss-cn-beijing.aliyuncs.com',
  :access_key_id => '1Ib17cOySykg7JeR',
  :access_key_secret => 'mmvbXa8mC23blsUVcMllW9HMydlmy8')

  bucket = client.get_bucket('aliimg')
  sites = [25, 2, 31, 1, 4, 3, 42, 43, 33, 336, 45, 337, 338, 341, 343, 342, 344, 345, 346, 348, 349, 350, 352, 353, 358, 357, 359, 360, 361, 366, 369, 371, 372, 374, 375, 376, 378]
  sites.each{|site_id|
    objs = bucket.list_objects(:prefix => "#{site_id}/spree_taxon/", :delimiter => '/')
    objs.each do |i|
      if i.is_a?(Aliyun::OSS::Object) # a object
        dirname = File.dirname( i.key)
        basename = File.basename( i.key)
        id = basename[/^[0-9]+/].to_i
        taxon = Spree::Taxon.where( id: id ).first
        if taxon
          if taxon.icon
            new_basename = basename.sub(/^[0-9]+/, taxon.icon.id.to_s)
            new_key = "#{dirname}/#{new_basename}"
            puts "object: #{i.key}, #{new_key}"
            bucket.copy_object( i.key, new_key)
          else
            puts "error: can not find taxon_icon #{i.key}"
          end
        else
          puts "error: can not find taxon #{i.key}"
        end
      end
    end
  }

end


namespace :spree_theme do
  desc "fix aliyun oss taxon icon file name
        in spree 3.4, taxon.icon become model taxon_icon"
  task :fix_oss_taxon_icon  => :environment do
    fix_oss_taxon_icon
   #fix_oss_taxon_icon_sample
  end
end
