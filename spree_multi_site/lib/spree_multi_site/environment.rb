require 'spree/core/environment_extension'
  module SpreeMultiSite
    class Environment
      include Spree::Core::EnvironmentExtension

      attr_accessor :site_scope_required_classes_from_other_gems, :preferences

      def initialize
        @preferences = Spree::MultiSiteConfiguration.new
        @site_scope_required_classes_from_other_gems = []
      end
    end
  end

