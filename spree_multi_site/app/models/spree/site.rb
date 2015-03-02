#encoding: utf-8
class Spree::Site < ActiveRecord::Base
  cattr_accessor :subdomain_regexp, :loading_fake_order_with_sample, :system_top_domain
  # system_top_domain is required, in middleware, we compare it with request.host, 
  # it tell us to initialize site by short_name or domain.

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
  
  has_many :stores, :dependent=>:destroy  
  #acts_as_nested_set
  accepts_nested_attributes_for :stores
  accepts_nested_attributes_for :users
  
  self.system_top_domain = 'dalianshops.com'
  # it is load before create site table. self.new would trigger error "Table spree_sites' doesn't exist"
  # db/migrate/some_migration is using Spree::Product, it has default_scope using Site.current.id
  # so it require a default value.
  self.subdomain_regexp = /\A([a-z0-9\-])*\Z/
  self.loading_fake_order_with_sample = false

  #these attr is only used when create site, it is unavailabe in other case.
  attr_accessor :admin_email, :admin_password, :admin_password_confirmation

  validates :name, length: 4..32 #"中国".length=> 2
  validates :short_name, uniqueness: true, presence: true, length: 4..32, format: {with: subdomain_regexp} #, unless: "domain.blank?"
  validates_uniqueness_of :domain, :allow_blank=>true 
  #attr_accessible :name, :domain, :short_name, :has_sample
  #generate short name fro name
  before_validation :set_short_name
  after_create :add_default_data
  
  class << self
    def dalianshops
      #in development, we may change site domain
      find_by_short_name('first')#find_by_domain
    end
    
    def current
      Spree::Store.current.site 
    end
    
    def current=(some_site)      
      Spree::Store.current = Spree::Store.unscoped.where( site_id: some_site.id ).first
      some_site      
    end

    # execute block with given site
    def with_site(new_site)
      original_current = self.current
      begin
        self.current = new_site
        yield( new_site )
      ensure
        self.current = original_current  
      end
    end
  
  end
  
  def dalianshops?
    self == self.class.dalianshops 
  end
  
  def current?
    self == self.class.current
  end
    
  def load_sample(  )
    require 'ffaker'
    # global tables
    #   countries,states, zones, zone_members, roles #admin
    # activators,
    # tables belongs to site
    #   addresses -> user(site)
    #   configuration(site)
    #   log_entries(site)
    #   orders(site)->[state_changes,inventory_units,tokenized_permission, orders_promotions ]
    #   [properties(site), prototypes(site)] -> properties_prototypes
    #                    , option_types(site)] ->option_type_prototypes
    #         ->products(site)->variants(site?)->assets(site)
    #   payment_methods(site)->payments->adjustments 
    #                                  ->payment_capture_events
    #                                  ->alipay_transactions( source )
    #   preference(site)
    #   tax_categories(site)-> tax_rates -> [shipping_methods, promotions,calculators]
    #   taxonomies(site) -> taxons(site) -> products_taxons(site?)
    #   user
    # to be confirm
    #   spree_tracker, state_changes
    #   return_authorizations
    #   mail_methods, 
    #   friendly_id_slugs
    # promotion_categories -> promotions -> promotion_rules
    #                                    -> promotion_actions 
    # product_promotion_rules, taxons_promotion_rules, 
    #   
    #   stores
    #:spree_refunds
    #:spree_return_authorization_inventory_units
    #:spree_return_authorizations
    #:spree_refund_reasons
    #:spree_customer_returns
    
    #:spree_reimbursements
    #:spree_reimbursement_types
    #:spree_reimbursement_credits
    #:spree_taxons_prototypes
    
    # unused table
    #   credit_cards(site?), gateways(site?)
    #
    raise "exists products" if self.products.any?
    self.class.with_site( self ) do 
        load_sample_products  
    end
    self
  end
  
  def unload_sample
    self.class.with_site( self ) do 
        self.orders.each{|order|
          order.state_changes.clear
          order.inventory_units.clear
          order.tokenized_permission.delete
          order.destroy
        }
        self.products.each{|product|
          product.variants.each{|variant| variant.inventory_units.clear}
          product.destroy! # it is acts_as_paranoid
        }
        self.properties.clear
        self.payment_methods.each{|pm| pm.destroy! } # it is acts_as_paranoid
        self.prototypes.clear
        self.option_types.clear
        self.shipping_categories.clear
        self.tax_categories.each{|pm| pm.destroy! } # it is acts_as_paranoid
        self.taxonomies.each{|taxonomy|
          taxonomy.root.destroy # remove taxons
          taxonomy.destroy
        }
        
        self.zones.each{|zone|
          zone.destroy
        }
        self.shipping_methods.clear
        
        #TODO fix taxons.taconomy_id
        self.users.includes(:ship_address,:bill_address).offset(1).each{|user|
          user.bill_address.destroy
          user.ship_address.destroy
          user.destroy
          } #skip first admin
        #shipping_method, calculator, creditcard, inventory_units, state_change,tokenized_permission
        #TODO remove image files
        self.assets.clear
        #TODO clear those tables
        # creditcarts,preferences
        self.state_changes.clear 
    end
    self
  end
  
  # current site'subdomain => short_name.dalianshops.com
  def subdomain
    short_name + '.' + system_top_domain
  end
  
  def admin_url
    "http://"+subdomain+"/admin"
  end
  
  private
  
  def add_default_data
    #current site is first, self is another.
    self.class.with_site( self ) do| site |
      site.stores.create!( name: site.name, code: site.short_name )  
      user_attributes = { email: site.admin_email, password: site.admin_password, password_confirmation: admin_password_confirmation }
      user = site.users.create!(user_attributes)
      user.spree_roles << Spree::Role.find_by_name('admin')      
      site.shipping_categories.create!( name: Spree.t(:default) )
    end
  end
  
  def load_sample_products
    file = File.join( Rails.application.root, 'db', 'samples', "seed.rb")
    load file
  end
  
  def load_sample_orders
    file = File.join( Rails.application.root, 'db', 'fake_order', "seed.rb")
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
