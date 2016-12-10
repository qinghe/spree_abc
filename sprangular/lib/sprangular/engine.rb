module Sprangular
  class Engine < ::Rails::Engine
    config.cached_paths = %w(layout directives products home cart promos)

    initializer "sprangular.assets.configure" do |app|
      assets = Rails.application.assets

      assets.register_mime_type 'text/html', '.html'
      assets.register_engine '.slim', Slim::Template

      Rails.application.config.assets.precompile += %w( sprangular.js sprangular.css bootstrap/* )
    end

    #initializer "sprangular.add_middleware" do |app|
    #  app.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    #    r301 '/products',          '/#!/products'
    #    r301 %r{^/products/(.+)$}, '/#!/products/$1'
    #    r301 %r{^/t/(.+)$},        '/#!/t/$1'
    #    r301 '/sign_in',           '/#!/sign-in'
    #    #spree_theme is using /cart
    #    #r301 '/cart',              '/#!/cart'
    #    r301 '/account',           '/#!/account'
    #    r301 '/spree/login',       '/#!/sign-in?redirect=y'
    #  end
    #end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    config.to_prepare &method(:activate).to_proc

  end
end
