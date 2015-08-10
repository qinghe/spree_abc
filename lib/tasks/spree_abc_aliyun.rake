namespace :spree_abc do
  namespace :aliyun do
    # there are product images, taxon icon, post cover, option_value image,
    #           ckeditor_assets, template_files
    # rake spree_abc:migrate_product_images_to_aliyun RAILS_ENV=aliyun_dev ORIGINAL_RAILS_ENV=development
    desc "Upload product images to Aliyun OSS, ORIGINAL_RAILS_ENV, RAILS_ENV reqruied"
    task :migrate_product_images_to_aliyun => :environment do
      raise "ALIYUN_ACCESS_ID required" if ENV['ALIYUN_ACCESS_ID'].blank?
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

    desc "Upload taxon images to Aliyun OSS, ORIGINAL_RAILS_ENV, RAILS_ENV reqruied"
    task :migrate_taxon_images_to_aliyun => :environment do
      raise "ALIYUN_ACCESS_ID required" if ENV['ALIYUN_ACCESS_ID'].blank?
      raise "ORIGINAL_RAILS_ENV required" if ENV['ORIGINAL_RAILS_ENV'].blank?
      original_rails_env = ENV['ORIGINAL_RAILS_ENV']
      Spree::Site.all.each{|site|
        Spree::Site.current = site
        Spree::Taxon.all.each do |taxon|
          next if taxon.icon.blank?
          image_full_path = Dir["#{Rails.root}/public/shops/#{original_rails_env}/#{site.id}/taxons/#{taxon.id}/original/#{taxon.icon_file_name}"].first
    puts "image_full_path =#{image_full_path}"
          if image_full_path.present?
            taxon.update(:icon => File.open(image_full_path))
            puts "uploading #{taxon.id}:#{taxon.icon_file_name}"
          end
        end
      }
    end

    desc "Upload ckeditor images to Aliyun OSS, ORIGINAL_RAILS_ENV, RAILS_ENV reqruied"
    task :migrate_ckeditor_images_to_aliyun => :environment do
      raise "ALIYUN_ACCESS_ID required" if ENV['ALIYUN_ACCESS_ID'].blank?
      raise "ORIGINAL_RAILS_ENV required" if ENV['ORIGINAL_RAILS_ENV'].blank?
      original_rails_env = ENV['ORIGINAL_RAILS_ENV']
      Spree::Site.all.each{|site|
        Spree::Site.current = site
        Ckeditor::Picture.all.each do |image|
          #:path => ":rails_root/public/shops/:rails_env/:site/ckeditor_assets/pictures/:id/:style_:basename.:extension",
          image_full_path = Dir["#{Rails.root}/public/shops/#{original_rails_env}/#{site.id}/ckeditor_assets/pictures/#{image.id}/original_#{image.data_file_name}"].first
    puts "image_full_path =#{image_full_path}"
          if image_full_path.present?
            image.update(:data => File.open(image_full_path))
            puts "uploading #{image.id}:#{image.data_file_name}"
          end
        end
      }
    end



  end
end
