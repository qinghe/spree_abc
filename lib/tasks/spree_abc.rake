require 'fileutils'

namespace :spree_abc do
  desc "export application.root/db/mmddyyyy.sql !"
  task :export_full_sql => :environment do
    file_path = "#{Rails.root}/db/full_sql/#{Time.now.strftime("%Y%m%d")}.sql"
    db_config = ActiveRecord::Base.configurations[Rails.env]
    mysqldump = "mysqldump -n -t -R --dump_date -u #{db_config['username']} --password='#{db_config['password']}' -h '#{db_config['host']}' #{db_config['database']}"
    ignore_tables = "--ignore-table=#{db_config['database']}.schema_migrations"
    puts "db_config=#{db_config.inspect}"
    #exclude schema_imgrations, it is filled by rails.
    puts "#{mysqldump}  > #{file_path}"
    `#{mysqldump} > #{file_path}`
  end
  # rake paperclip:refresh:thumbnails CLASS=Spree::Image
  # rake spree_abc:refresh_images[large]
  task :refresh_images, [:style] => :environment do |t, args|
    image_style = args.style
    klass = ( ENV['CLASS'] || 'Spree::Image' )
    Rails.logger.debug "start task :refresh_images #{image_style}"
    Spree::Site.all.each{|site|
      Spree::Site.current = site
      klass.constantize.all.each{|asset|
        if asset.attachment.present?
          asset.attachment.reprocess!(image_style.to_sym)
        else
          puts "warning asset #{asset.id} #{asset.attachment_file_name} is missing"
        end
      }

    }
    Rails.logger.debug "end task :refresh_images"
  end

  desc "Load sample into design/demo site"
  task :load_sample => :environment do
    Spree::Site.find(2).load_sample
    Spree::Site.find(3).load_sample
    #{}`bundle exec rspec`
  end

  desc "create sitemap file for a shop
        ex. rake spree_abc:create_sitemap[2]"
  task :create_sitemap, [:site_id ] => :environment do |t, args|
    site_id= args.site_id
    Spree::Site.current = Spree::Site.find( site_id )
    SitemapService.new( Spree::Store.current).perform
  end

  desc "create robots file for a shop
        ex. rake spree_abc:create_robots[2]"
  task :create_robots, [:site_id ] => :environment do |t, args|
    site_id= args.site_id
    Spree::Site.current = Spree::Site.find( site_id )
    RobotsService.new( Spree::Store.current).perform
  end

  desc "create shop related link files, for sitemap and robots"
  task :create_links => :environment do |t, args|
    # public/shop_url -> public/shops/development/2
    Spree::Store.all.each{|store|
      next unless store.url.present?
      #oldname, newname
      src = store.document_path
      des = File.join(Rails.root,'public', store.url )
      #商店目录没有创建
      unless File.exists?( src )
        FileUtils.mkdir( src )
        puts "Create #{src}"
      end

      if File.exists?( des )
        puts "Exists #{des}"
      else
        FileUtils.ln_s src, des
      end
    }
  end

end
