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

  # there are product images, taxon icon, option_value image, post cover,
  #           ckeditor_assets, template_files
  # rake spree_abc:migrate_product_images_to_aliyun RAILS_ENV=aliyun_dev ORIGINAL_RAILS_ENV=development
  desc "Upload images to Aliyun OSS, ORIGINAL_RAILS_ENV, RAILS_ENV reqruied"
    task :migrate_product_images_to_aliyun => :environment do
      raise "ORIGINAL_RAILS_ENV required" if ENV['ORIGINAL_RAILS_ENV'].blank?
      original_rails_env = ENV['ORIGINAL_RAILS_ENV']
      Spree::Site.all.each{|site|
        Spree::Site.current = site
        Spree::Image.all.each do |image|
          extname = File.extname image.attachment_file_name # .jpg
          basename = File.basename image.attachment_file_name, extname
          image_full_path = Dir["#{Rails.root}/public/shops/#{original_rails_env}/#{site.id}/products/#{image.id}/#{basename}_original#{extname}"].first
puts "image_full_path =#{image_full_path}"          
          if image_full_path.present?
            image.update(:attachment => File.open(image_full_path))
            puts "uploading #{image.id}:#{image.attachment_file_name}"
          end
        end
      }
    end

end
