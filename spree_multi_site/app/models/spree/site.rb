#encoding: utf-8
class Spree::Site < ActiveRecord::Base
  cattr_accessor :unknown,:subdomain_regexp, :loading_fake_order_with_sample, :dalianshops_url
  has_many :taxonomies,:inverse_of =>:site,:dependent=>:destroy
  has_many :products,:inverse_of =>:site,:dependent=>:destroy
  has_many :orders,:inverse_of =>:site,:dependent=>:destroy
  has_many :users,:dependent=>:destroy, :class_name=>"Spree::User" #Spree.user_class.to_s
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
  
  #acts_as_nested_set
  accepts_nested_attributes_for :users
  
  #app_configuration require site_id
  self.unknown = Struct.new(:id).new(0)
  # it is load before create site table. self.new would trigger error "Table spree_sites' doesn't exist"
  # db/migrate/some_migration is using Spree::Product, it has default_scope using Site.current.id
  # so it require a default value.
  self.subdomain_regexp = /^([a-z0-9\-])*$/
  self.loading_fake_order_with_sample = false
  self.dalianshops_url = "www.dalianshops.com"
  validates :name, length: 4..32 #"中国".length=> 2
  validates :short_name, uniqueness: true, presence: true, length: 4..32, format: {with: subdomain_regexp} #, unless: "domain.blank?"
  validates_uniqueness_of :domain, :allow_blank=>true 
  attr_accessible :name, :domain, :short_name, :has_sample
  #generate short name fro name
  before_validation :set_short_name
  
  class << self
    def dalianshops
      find_by_domain dalianshops_url
    end
    
    def current
      ::Thread.current[:spree_site] || self.unknown 
    end
    
    def current=(some_site)
      ::Thread.current[:spree_site] = some_site      
    end
    
    # execute block with given site
    def with_site(new_site)
      original_current = self.current
      begin
        self.current = new_site
        yield
      ensure
        self.current = original_current  
      end
    end
  end
  
  def dalianshops?
    self.domain == dalianshops_url
  end
  
  def unknown?
    !(self.id>0)
  end
  
  def load_sample(be_loading = true)
    require 'ffaker'
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
    else
      load_sample_products  
    end
    
   self.class.current = original_current_website
  end
  
  # current site'subdomain => short_name.dalianshops.com
  def subdomain
    ([self.short_name] + self.class.dalianshops.domain.split('.')[1..-1]).join('.')
  end
  
  def admin_url
    "http://"+subdomain+"/admin"
  end
  
  private
  def load_sample_products
    file = Pathname.new(File.join(SpreeMultiSite::Config.seed_dir, 'samples', "seed.rb"))
    load file
  end
  
  def load_sample_orders
    file = Pathname.new(File.join(SpreeMultiSite::Config.seed_dir, 'fake_order', "seed.rb"))
    load file
  end
   
  def set_short_name
    if short_name.blank?
      self.short_name = name.to_url 
      if self.class.exists?(:short_name=> self.short_name)
        self.short_name << "-#{(self.class.last.id+1).to_s}"
      end
    end
  end
    
end
