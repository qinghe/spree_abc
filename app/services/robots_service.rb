  class RobotsService
    attr_accessor :store

    def initialize( store )
      self.store =  store
    end

    # taxon
    # taxon/product
    # taxon/post

    def perform
      path = File.join( Rails.root, 'public', store.path, 'robots.txt')
      #sitemap = File.join( store.path, 'robots.txt')
      robots = <<-HERE
User-agent: *
Disallow: /checkouts
Disallow: /orders
Disallow: /countries
Disallow: /line_items
Disallow: /password_resets
Disallow: /states
Disallow: /user_sessions
Disallow: /users
Sitemap: http://#{store.url}/sitemap.xml.gz
HERE

      open( path, 'w' ){|file|
        file.puts robots
      }
    end


  end
