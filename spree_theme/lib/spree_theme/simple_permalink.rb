module SpreeTheme
    module SimplePermalink
      extend ActiveSupport::Concern

      included do
        class_attribute :simple_permalink_options
      end

      module ClassMethods
        def make_simple_permalink( options={})
          options[:slug_field] ||= :slug
          options[:title_field ] ||= :title
          self.simple_permalink_options = options

          before_validation(:on => :create) { save_permalink }
        end
      end
      
      def save_permalink
        self.slug = self.title.parameterize
      end
    end
end