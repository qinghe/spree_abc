require 'active_record/fixtures'

module SpreeMultiSite
    
    class Fixtures < ActiveRecord::Fixtures
      
      @@all_cached_models = Hash.new { |h,k| h[k] = {} }
      #handle has_and_belongs_to_many join table , key is association_reflection
      @@all_cached_habtm_rows = Hash.new { |h,k| h[k] = [] } 
      
      def self.cache_for_table(table_name)
        @@all_cached_models[table_name]
      end
      def self.cache_models(table_name, models_map)
        cache_for_table(table_name).update(models_map)
      end
      def self.cache_habtm_rows(habtm_association, rows)
        @@all_cached_habtm_rows[habtm_association].concat rows
      end            
      # Since create sample for each site, original key generating in Fixtures  
      # would not work. We should load fixture in proper order, all created model  
      # instances are cached, then the right foreign id could be set while create  
      # model instance which contains belongs_to association. 
      # ex. assets belongs_to variant, variant should be loaded before assets.
      # Replace this method to prevent the table being emptied on each call. Needed
      # when both core & auth have user fixtures, see below for code commented out.
      #
      def self.create_fixtures(fixtures_directory, table_names, class_names = {})
        table_names = [table_names].flatten.map { |n| n.to_s }
        if class_names.empty?
          table_names.each { |n|
            class_names[n.tr('/', '_').to_sym] = n.classify if n.include?('/') 
          }
        end
        # FIXME: Apparently JK uses this.
        connection = block_given? ? yield : ActiveRecord::Base.connection

        files_to_read = table_names.reject { |table_name|
          fixture_is_cached?(connection, table_name)
        }

        unless files_to_read.empty?
          connection.disable_referential_integrity do
            fixtures_map = {}
            
            fixture_files = files_to_read.map do |path|
              table_name = path.tr '/', '_'

              fixtures_map[path] = self.new(
                connection,
                table_name,
                class_names[table_name.to_sym] || table_name.classify,
                ::File.join(fixtures_directory, path))
            end

            all_loaded_fixtures.update(fixtures_map)

            connection.transaction(:requires_new => true) do
              fixture_files.each do |ff|
                models_map = {}
                conn = ff.model_class.respond_to?(:connection) ? ff.model_class.connection : connection
                client_connection = conn.instance_variable_get(:@connection)
                table_rows = ff.table_rows
                model_class= ff.model_class
                # REMOVED BY SPREE
                # table_rows.keys.each do |table|
                #   conn.delete "DELETE FROM #{conn.quote_table_name(table)}", 'Fixture Delete'
                # end
                habtm_association = model_class.reflect_on_all_associations(:has_and_belongs_to_many).first
                  
                table_rows.each do |table_name,rows|
                  #handle join table separately, assume one model only have one HABTM association
                  next if habtm_association.present? and table_name == habtm_association.options[:join_table]
                  #correct it after create all objects.
                    rows.each do |row|
                      #conn.insert_fixture(row, table_name)
                      primary_key =  ff.identify_primary_key(row)
                      row.delete( "id" )
                 
                      if row['parent_id'].present? # nested set, taxon
                        parent_key = ActiveRecord::Fixtures.identify(row['parent_id'])
                        row['parent_id'] = models_map[parent_key]
                        if row['parent_id']==0                        
Rails.logger.debug "model_class=#{ff.model_class},primary_key=#{primary_key},table_name=#{table_name},parent_id=#{row['parent_id']}"
                    raise "can not find parent reference: #{row.inspect},parent_key=#{parent_key},models_map=#{models_map.inspect}"
                        end 
                      end                      
Rails.logger.debug "model_class=#{ff.model_class},primary_key=#{primary_key},table_name=#{table_name},parent_id=#{row['parent_id']}"                            
                      model_instance = model_class.new()
                      model_instance.assign_attributes(row,:without_protection => true)
                      if table_name=~/taxonomies|tax_rates|shipping_methods|products|users|shipments/ 
                        # taxonomies has :after_save to create taxon root, insert_fixture would avoid that.
                        # tax_rate has one calculator, calculator belongs to tax_rate, 
                        # we have to create tax_rate before calculator since calculator require tax_rate.id
                        # tax_rate has calculator presence validation, so set validate=>false here. so does shipping_method
                        # TODO for product price validation 
                        #model_instance.save!(:validate => false), it may not work, 
                        conn.insert_fixture(row, table_name)
                        models_map[primary_key] = client_connection.last_id 
                      else
                        model_instance.save!
                        models_map[primary_key] = model_instance.id 
                      end
#puts "primary_key=#{primary_key},model_instance=#{model_instance.inspect}"  
                    end                  
                end
                #create HABTM join talbe record with real foreign_key and mock association_foreign_key
                #because association may not be created yet
                #correct it after load all fixtures
                if habtm_association.present?
                  habtm_rows =table_rows[habtm_association.options[:join_table]]
#Rails.logger.debug "cache habtm_association=#{habtm_association.options[:join_table]},#{habtm_rows.length}---------------------"                  
                  cache_habtm_rows(habtm_association, habtm_rows)                                        
                end
                cache_models(ff.table_name, models_map)
              end

              # Cap primary key sequences to max(pk).
              if connection.respond_to?(:reset_pk_sequence!)
                table_names.each do |table_name|
                  connection.reset_pk_sequence!(table_name.tr('/', '_'))
                end
              end
            end

            cache_fixtures(connection, fixtures_map)
          end
        end
        cached_fixtures(connection, table_names)
      end
      
      #we have to create join table record after normal fixtures created.
      def self.create_habtm_records
        @@all_cached_habtm_rows.each_pair{|habtm_association, rows|
          foreign_models_map =  cache_for_table(habtm_association.active_record.table_name)
          association_foreign_models_map = cache_for_table(habtm_association.klass.table_name)
          association_klass = habtm_association.klass
          rows.each{|row|
            #set real foreign_key from created models
#  puts "original_row=#{row.inspect},\nmodel_class=#{association_klass}"
            row[ habtm_association.foreign_key ] = foreign_models_map[ row[ habtm_association.foreign_key ]]
            row[ habtm_association.association_foreign_key ] = association_foreign_models_map[ row[ habtm_association.association_foreign_key ]]
if row[ habtm_association.foreign_key ].nil? or row[ habtm_association.association_foreign_key ].nil?
  #puts "row[#{habtm_association.foreign_key}]=#{row[ habtm_association.foreign_key ]},#{foreign_models_map.length}"
  #puts "row[#{habtm_association.association_foreign_key}]=#{row[ habtm_association.association_foreign_key ]},#{association_foreign_models_map.keys.inspect} "
  raise "can not find foreign reference"
end
            association_klass.connection.insert_fixture(row, habtm_association.options[:join_table])
          }
        }
        @@all_cached_habtm_rows.clear
      end
      
  
      # Replace this method to handle associations in yml.
          # Return a hash of rows to be inserted. The key is the table, the value is
      # a list of rows to insert to that table.
      def table_rows
        now = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
        now = now.to_s(:db)
        site_column = 'site_id'
        # allow a standard key to be used for doing defaults in YAML
        fixtures.delete('DEFAULTS')
  
        # track any join tables we need to insert later
        rows = Hash.new { |h,table| h[table] = [] }
  
        rows[table_name] = fixtures.map do |label, fixture|
          row = fixture.to_hash
  
          if model_class && model_class < ActiveRecord::Base
            # fill in timestamp columns if they aren't specified and the model is set to record_timestamps
            if model_class.record_timestamps
              timestamp_column_names.each do |name|
                row[name] = now unless row.key?(name)
              end
            end
            #set current site id if they aren't specified
            if model_class.column_names.include? site_column
              row[site_column] = Spree::Site.current.id unless row.key?(site_column)
            end  
            # interpolate the fixture label
            row.each do |key, value|
              row[key] = label if value == "$LABEL"
            end
  
            # generate a primary key if necessary
            if has_primary_key_column? && !row.include?(primary_key_name)
#Rails.logger.debug "label=#{label},identify=#{ActiveRecord::Fixtures.identify(label)}"              
              row[primary_key_name] = ActiveRecord::Fixtures.identify(label)
            end
  
            # If STI is used, find the correct subclass for association reflection
            reflection_class =
              if row.include?(inheritance_column_name)
                row[inheritance_column_name].constantize rescue model_class
              else
                model_class
              end
  
            reflection_class.reflect_on_all_associations.each do |association|
              case association.macro
              when :belongs_to
                # Do not replace association name with association foreign key if they are named the same
                fk_name = (association.options[:foreign_key] || "#{association.name}_id").to_s
#puts "association.name=#{association.name}, "                
                if association.name.to_s != fk_name && value = row.delete(association.name.to_s)
                  
                  if association.options[:polymorphic] 
                    if value.sub!(/\s*\(([^\)]*)\)\s*$/, "")
                      # support polymorphic belongs_to as "label (Type)"
                      row[association.foreign_type] = $1
                    end
                    #puts "cached_table=#{self.class.cache_for_table(row[association.foreign_type].constantize.table_name).inspect}"
                    #puts "row[association.foreign_type].constantize.table_name=#{row[association.foreign_type].constantize.table_name}"
                    row[fk_name] = self.class.cache_for_table(row[association.foreign_type].constantize.table_name)[ActiveRecord::Fixtures.identify(value)]
                  else
                    row[fk_name] = self.class.cache_for_table(association.klass.table_name)[ActiveRecord::Fixtures.identify(value)]
                  end
                  if row[fk_name].nil?
                    puts "looking for #{table_name},row=#{row.inspect}"
                    #puts "self.class.cache_for_table('spree_variants')=#{self.class.cache_for_table('spree_variants').keys.inspect}"
                    puts "@@all_cached_models=#{@@all_cached_models.keys.inspect}"
                    raise "can not find foreign reference: #{reflection_class}.#{fk_name}" 
                  end 
                  #row[fk_name] = ActiveRecord::Fixtures.identify(value)
                end
              when :has_and_belongs_to_many
                if (targets = row.delete(association.name.to_s))
                  targets = targets.is_a?(Array) ? targets : targets.split(/\s*,\s*/)
                  table_name = association.options[:join_table]
                  rows[table_name].concat targets.map { |target|
#                    Rails.logger.debug "target=#{target},#{ActiveRecord::Fixtures.identify(target)}"
                    { association.foreign_key             => row[primary_key_name],
                      association.association_foreign_key => ActiveRecord::Fixtures.identify(target) }
                  }
                end
              end
            end
          end
  
          row
        end
        rows
      end

      # generate a primary key if necessary
      def identify_primary_key(row)
 #        Rails.logger.debug "primary_key_name=#{primary_key_name},val=#{row[primary_key_name]}, has_primary_key_column?=#{has_primary_key_column?} "
         row[primary_key_name] if has_primary_key_column? && row.include?(primary_key_name)
      end
    end
  
end