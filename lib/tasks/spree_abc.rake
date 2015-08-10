namespace :spree_abc do
  desc "export application.root/db/mmddyyyy.sql !"
  task :export_full_sql => :environment do
    file_path = "#{Rails.root}/db/full_sql/#{Time.now.strftime("%Y%m%d")}.sql"
    db_config = ActiveRecord::Base.configurations[Rails.env]
    mysqldump = "mysqldump -n -t -R --dump_date -u #{db_config['username']} --password='#{db_config['password']}' -h '#{db_config['host']}' #{db_config['database']}"
    puts "db_config=#{db_config.inspect}"
    #exclude schema_imgrations, it is filled by rails.
    puts "#{mysqldump} --ignore-table=#{db_config['database']}.schema_migrations > #{file_path}"
    `#{mysqldump} --ignore-table=#{db_config['database']}.schema_migrations > #{file_path}`
  end
  # rake paperclip:refresh:thumbnails CLASS=Spree::Image
  # rake spree_abc:refresh_images[large]
  task :refresh_images, [:style] => :environment do |t, args|
    image_style = args.style
    Rails.logger.debug "start task :refresh_images #{image_style}"
    Spree::Site.all.each{|site|
      Spree::Site.current = site
      if site.assets.any?
        site.assets.each{|asset|
          asset.attachment.reprocess!(image_style.to_sym)
        }
      end
    }
    Rails.logger.debug "end task :refresh_images"
  end



end
