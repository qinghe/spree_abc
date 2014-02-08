module SpreeMultiSite
  class Engine < Rails::Engine
    engine_name 'spree_multi_site'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.multisite.environment", :before => "spree.environment" do |app|
      SpreeMultiSite::Config = Spree::MultiSiteConfiguration.new
      
      # preferences contains two kind of records
      # 1. override AppConfiguration's default value.
      #     a. some preferences in AppConfiguration are for whole application, so override record site_id=0, like seed_dir
      #        this kind preference's description start with 'global'
      #     b. some preferences are for one site, so override record site_id>0, like :default_seo_title 
      #    
      # 2. preference in other models, site_id>0, key contain model instance id.  
       
      #hack this class before :load_config_initializers, Spree::Config is using while initialize       
      Spree::AppConfiguration.class_eval do
        #replace original :preference_cache_key, add current_site.id as part of key
        #fix error Duplicate entry 'spree/app_configuration/site_url/1' 
        def preference_cache_key(name)
          global_preferences = ["seed_dir"]
          some_key = nil
          if global_preferences.include? name#preference_description( name ).to_s.start_with? "global_"
            some_key =[self.class.name, name, 0].join('::').underscore
          else
            some_key =[self.class.name, name, Spree::Site.current.id].join('::').underscore            
          end
          some_key 
        end
      end
    end
      
    initializer "spree.multisite.add_middleware" do |app|
      app.middleware.use SpreeMultiSite::Middleware
    end  
      
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    #spree_abc require #{config.root}/app/mailers
    config.autoload_paths += %W(#{config.root}/app/models/spree #{config.root}/app/jobs)
    config.to_prepare &method(:activate).to_proc
    
    
  end
end
