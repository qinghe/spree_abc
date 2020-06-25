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
        #in mysql 5.5, grouped index column length is 60byte, it is tested on aliyun server.
        #in friendly_id_slugs table slug(30)+sluggable_type(15)+scope(15)
        #keep slug <30
        self.slug = self.title.parameterize[0,30]
      end
    end
end
