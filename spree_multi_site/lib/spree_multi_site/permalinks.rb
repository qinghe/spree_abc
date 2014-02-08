require 'spree/core/permalinks'
#override permalinks, add site scope
class<<  Spree::Core::Permalinks::ClassMethods

        def make_permalink(options={})
          options[:field] ||= :permalink
          self.permalink_options = options

          #add site scope
          #validates permalink_options[:field], :uniqueness => true
          validates permalink_options[:field], :uniqueness => { :scope => [:site_id] }
          
          if self.table_exists? && self.column_names.include?(permalink_options[:field].to_s)
            before_validation(:on => :create) { save_permalink }
          end
        end

end