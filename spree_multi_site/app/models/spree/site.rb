class Spree::Site < ActiveRecord::Base
  cattr_accessor :unknown,:subdomain_regexp, :loading_fake_order_with_sample
  has_many :taxonomies,:inverse_of =>:site,:dependent=>:destroy
  has_many :products,:inverse_of =>:site,:dependent=>:destroy
  has_many :orders,:inverse_of =>:site,:dependent=>:destroy
  has_many :users,:dependent=>:destroy, :class_name =>Spree.user_class.to_s.sub("Spree::","")
  #FIXME,:inverse_of =>:site, it cause  uninitialized constant Spree::Site::, 
  has_many :tax_categories,:inverse_of =>:site,:dependent=>:destroy
  
  has_many :shipping_categories,:dependent=>:destroy
  has_many :shipping_methods,:dependent=>:destroy
  has_many :prototypes,:dependent=>:destroy
  has_many :option_types,:dependent=>:destroy
  has_many :properties,:dependent=>:destroy
  has_many :payment_methods,:dependent=>:destroy
  has_many :assets,:dependent=>:destroy
  has_many :zones,:dependent=>:destroy
  has_many :state_changes,:dependent=>:destroy
  
  acts_as_nested_set
  accepts_nested_attributes_for :users
  
  #app_configuration require site_id
  self.unknown = Struct.new(:id).new(0)
  # it is load before create site table. self.new would trigger error "Table spree_sites' doesn't exist"
  # db/migrate/some_migration is using Spree::Product, it has default_scope using Site.current.id
  # so it require a default value.
  self.subdomain_regexp = /^([a-z0-9\-])*$/
  self.loading_fake_order_with_sample = false
  validates_presence_of   :name
  validates :short_name, presence: true, length: 4..32, format: {with: subdomain_regexp} #, unless: "domain.blank?"
  
  
  class << self
    def admin_site
      self.first
    end
    
    def current
      ::Thread.current[:spree_multi_site] || self.unknown 
    end
    
    def current=(some_site)
      ::Thread.current[:spree_multi_site] = some_site      
    end
  end
  
  
  def load_sample(be_loading = true)
    # global talbes
    #   countries,states, zones, zone_members, roles #admin
    # activators,
    # tables belongs to site
    #   addresses -> user(site)
    #   configuration(site)
    #   log_entries(site)
    #   orders(site)->[state_changes,inventory_units,tokenized_permission]
    #   [properties(site), prototypes(site)] -> properties_prototypes
    #                    , option_types(site)] ->option_type_prototypes
    #         ->products(site)->variants(site?)->assets(site)
    #   payment_methods(site)->payments->adjustments 
    #   preference(site)
    #   tax_categories(site)-> tax_rates -> [shipping_methods, promotions,calculators]
    #   taxonomies(site) -> taxons(site) -> products_taxons(site?)
    #   user
    # to be confirm
    #   spree_tracker, state_changes
    #   return_authorizations
    #   mail_methods, pending_promotions, product_promotion_*
    # unused table
    #   credit_cars(site?), gateways(site?)
    #
    original_current_website, self.class.current = self.class.current, self 
    
    if be_loading!=true #
      self.orders.each{|order|
        order.state_changes.clear
        order.inventory_units.clear
        order.tokenized_permission.delete
        order.destroy
      }
      self.products.each{|product|
        product.variants.each{|variant| variant.inventory_units.clear}
      }
      self.products.clear
      self.properties.clear
      self.payment_methods.each{|pm| pm.delete}
      self.prototypes.clear
      self.option_types.clear
      self.shipping_categories.clear
      self.tax_categories.clear
      self.taxonomies.each{|taxonomy|
        taxonomy.root.destroy # remove taxons
        taxonomy.destroy
      }
      
      self.zones.each{|zone|
        zone.destroy
      }
      self.shipping_methods.clear
      
      #TODO fix taxons.taconomy_id
      self.users.find(:all,:include=>[:ship_address,:bill_address],:offset=>1, :order=>'id').each{|user|
        user.bill_address.destroy
        user.ship_address.destroy
        user.destroy
        } #skip first admin
      #shipping_method, calculator, creditcard, inventory_units, state_change,tokenized_permission
      #TODO remove image files
      self.assets.clear
      #FIXME seems it do not work 
      self.clear_preferences #remove preferences
      #TODO clear those tables
      # creditcarts,preferences
      self.state_changes.clear 
      return
    end
    
    require 'ffaker'
    require 'erb'
    require 'spree_multi_site/custom_fixtures'
    # only load sample from one folder. by default is 'Rails.application.root/db/sample'
    # could override it by setting Spree::Config.data_path
    sample_dirs = ['sample']
    sample_dirs << 'fake_order' if self.class.loading_fake_order_with_sample                                               
    for sample_dir in sample_dirs    
      dir = File.join(SpreeMultiSite::Config.seed_dir,sample_dir)
  #Rails.logger.debug "load sample from dir=#{dir}"
      fixtures = ActiveSupport::OrderedHash.new
      ruby_files = ActiveSupport::OrderedHash.new
      Dir.glob(File.join(dir , '**/*.{yml,csv,rb}')).each do |fixture_file|
        ext = File.extname fixture_file
        if ext == ".rb"
          ruby_files[File.basename(fixture_file, '.*')] = fixture_file
        else
          fixtures[fixture_file.sub(dir, "")[1..-1]] = fixture_file
        end
      end
      # put eager loading model ahead, 
      fixture_indexes = ['sites',
        'shipping_categories','payment_methods',
        'properties','option_types','option_values', 
        'tax_categories','tax_rates','shipping_methods','promotions','calculators',
        'products','product_properties','product_option_types','variants','assets', 
        'taxonomies','taxons',
        'addresses','users','orders','line_items','shipments','adjustments']
      #{:a=>1, :b=>2, :c=>3}.sort => [[:a, 1], [:b, 2], [:c, 3]] 
      sorted_fixtures = fixtures.sort{|a,b|
        key1,key2  = a.first.sub(".yml", "").sub("spree/", ""), b.first.sub(".yml", "").sub("spree/", "")  #a.first is relative_path
  #puts "a=#{a.inspect},b=#{b.inspect} \n key1=#{key1}, key2=#{key2}, #{(fixture_indexes.index(key1)<=> fixture_indexes.index(key2)).to_i}"      
        i = (fixture_indexes.index(key1)<=> fixture_indexes.index(key2)).to_i
        i==0 ? -1 : i # key not in fixture_indexes should be placed ahead.
      }
      SpreeMultiSite::Fixtures.reset_cache
      sorted_fixtures.each do |relative_path , fixture_file|
        # load fixtures  
        # load_yml(dir,fixture_file)
  Rails.logger.debug "loading fixture_file=#{fixture_file}"
        if fixture_file =~/users.yml/ #user class may be legacy_user or user
          SpreeMultiSite::Fixtures.create_fixtures(dir, relative_path.sub(".yml", ""),{:spree_users=>Spree.user_class})
        else
          SpreeMultiSite::Fixtures.create_fixtures(dir, relative_path.sub(".yml", ""))            
        end
      end
  #puts "create habtm records"      
      SpreeMultiSite::Fixtures.create_habtm_records    
      ruby_files.sort.each do |fixture , ruby_file|
        # an invoke will only execute the task once
  Rails.logger.debug  "loading ruby #{ruby_file}"
        load ruby_file
      end
    end  #for sample_dir  
    self.class.current = original_current_website
  end
  
  # current site'subdomain => short_name.dalianshops.com
  def subdomain
    ([self.short_name] + self.class.admin_site.domain.split('.')[1..-1]).join('.')
  end
    
end
