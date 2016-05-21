module SpreeTheme
  class Engine < Rails::Engine
    isolate_namespace Spree
    engine_name 'spree_theme'

    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/models/spree/calculator)
    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree.promo.register.promotion.calculators' do |app|
      app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::RelatedProductDiscount
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
    initializer "spree.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        store/spree_theme.*
        jquery.jstree/themes/spree2/style.css
      ]
    end

    config.to_prepare &method(:activate).to_proc
  end
end
