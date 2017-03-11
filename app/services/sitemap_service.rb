  class SitemapService
    attr_accessor :store

    def initialize( store )
      self.store =  store
    end

    # taxon
    # taxon/product
    # taxon/post

    def perform
      # store -> template_theme -> assigned_menus
      # each assigned-menu
      #   each page
      #     each page.products
      #     each page.posts
      taxons = get_valid_taxons


      SitemapGenerator::Sitemap.default_host = "http://#{store.url}"

      ##
      ## If using Heroku or similar service where you want sitemaps to live in S3 you'll need to setup these settings.
      ##

      ## Pick a place safe to write the files
      # SitemapGenerator::Sitemap.public_path = 'tmp/'

      ## Store on S3 using Fog - Note must add fog to your Gemfile.
      # SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(aws_access_key_id:     Spree::Config[:s3_access_key],
      #                                                                     aws_secret_access_key: Spree::Config[:s3_secret],
      #                                                                     fog_provider:          'AWS',
      #                                                                     fog_directory:         Spree::Config[:s3_bucket])

      ## Inform the map cross-linking where to find the other maps.
      # SitemapGenerator::Sitemap.sitemaps_host = "http://#{Spree::Config[:s3_bucket]}.s3.amazonaws.com/"

      ## Pick a namespace within your bucket to organize your maps. Note you'll need to set this directory to be public.
      # "/shops/development/2" => "shops/development/2"
      SitemapGenerator::Sitemap.sitemaps_path = store.path.slice( 1..-1)

      SitemapGenerator::Sitemap.create do
        # Put links creation logic here.
        #
        # The root path '/' and sitemap index file are added automatically.
        # Links are added to the Sitemap in the order they are specified.
        #
        # Usage: add(path, options = {})
        #        (default options are used if you don't specify)
        #
        # Defaults: priority: 0.5, changefreq: 'weekly',
        #           lastmod: Time.now, host: default_host
        #
        #
        # Examples:
        #
        # Add '/articles'
        #
        #   add articles_path, priority: 0.7, changefreq: 'daily'
        #
        # Add individual articles:
        #
        #   Article.find_each do |article|
        #     add article_path(article), lastmod: article.updated_at
        #   end

        #FIXME consider that there are more than 1M products
        taxons.each{|taxon|
          add_taxon(taxon)

          taxon.posts.each{|post|
            add_post(post, taxon)
          }

          taxon.products.each{|product|
            add_product(product, taxon)
          }
        }
      end


    end


    def get_valid_taxons
      template_resources = store.template_theme.try(:template_resources )
      return [] unless template_resources.present?
      template_resource_taxons = template_resources.select{|resource|
        resource.source_class ==  SpreeTheme.taxon_class
      }

      taxons = []
      template_resource_taxons.each{|template_resource|
        taxon = template_resource.source
        if taxon.root?
          taxons+= taxon.descendants
        else
          taxons.push taxon
        end
      }
      taxons.uniq!
      taxons.select{|taxon|
        #忽略外链
        next if taxon.html_attributes.key? 'href' 
        taxon.home? || taxon.context_list? || taxon.context_blog?
      }

    end

  end
