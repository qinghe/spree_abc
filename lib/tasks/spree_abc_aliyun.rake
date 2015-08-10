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

    desc "replace image src which using ckeditor images with Aliyun OSS"
    task :replace_image_src_for_aliyun => :environment do
    # taxon.description, product.description, post.body

             [Spree::Taxon, Spree::Product, Spree::Post].each{|model_class|
               puts "----------------------#{model_class.name}----------------------"
               column = (model_class == Spree::Post ? :body : :description)
               model_class.unscoped.all.each{|model|
                 description = model.send column
                 if description.present?
                   doc = Nokogiri::HTML::DocumentFragment.parse(description)
                   Spree::Site.with_site( Spree::Site.find( model.site_id ) ) do
                     doc.css('img').each{| img |
                         #file.puts "#{model.id}, #{img.attr( 'src' )}"
                         if img.attr( 'src' ) =~ /pictures\/([\d]+)\/content/
                           picture = Ckeditor::Picture.where( id: $1 ).first
                           if picture
                             img['src']= picture.url
                           else
                             img['src']= ''
                           end
                         else
                           img['src']= ''
                         end
                         puts "#{model.id},#{img['src']}"
                         model.send "#{column}=", doc.to_html
                     }
                     model.save!
                   end
                 end
               }
             }
             #taxon.description, product.description, post.body



    end

    desc "Replace image src for aliyun, it is only called internally
      model_class is string 'spree/post'
      rake spree_abc:aliyun:replace_image_src[spree/product,2]"
    task :replace_image_src, [:model_class, :model_id] => :environment do |t, args|
      model_class = args.model_class.classify.constantize
      model = model_class.unscoped.find args.model_id

      Spree::Site.with_site( Spree::Site.find( model.site_id ) ) do
        doc = Nokogiri::HTML(model.description)
        imgs = doc.css('img')

        puts "images = #{imgs}"
      end

    end

  end
end
