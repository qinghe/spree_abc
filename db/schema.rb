# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141107113617) do

  create_table "ckeditor_assets", :force => true do |t|
    t.integer  "site_id",                         :default => 0, :null => false
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "ckeditor_assets", ["site_id", "assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["site_id", "assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "spree_activators", :force => true do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "event_name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy", :default => "all"
    t.string   "code"
    t.boolean  "advertise",    :default => false
    t.string   "path"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "spree_ad_hoc_option_types", :force => true do |t|
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.integer  "position",            :default => 0,     :null => false
    t.string   "price_modifier_type"
    t.boolean  "is_required",         :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "spree_ad_hoc_option_values", :force => true do |t|
    t.integer  "ad_hoc_option_type_id"
    t.integer  "option_value_id"
    t.integer  "position"
    t.boolean  "selected"
    t.decimal  "price_modifier",        :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "cost_price_modifier",   :precision => 8, :scale => 2
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
  end

  create_table "spree_ad_hoc_option_values_line_items", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "ad_hoc_option_value_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "spree_ad_hoc_variant_exclusions", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_addresses", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.string   "company"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "city_id",           :default => 0
    t.string   "city_name"
  end

  add_index "spree_addresses", ["firstname"], :name => "index_addresses_on_firstname"
  add_index "spree_addresses", ["lastname"], :name => "index_addresses_on_lastname"

  create_table "spree_adjustments", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.integer  "originator_id"
    t.string   "originator_type"
    t.decimal  "amount",          :precision => 10, :scale => 2
    t.string   "label"
    t.boolean  "mandatory"
    t.boolean  "eligible",                                       :default => true
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.string   "state"
  end

  add_index "spree_adjustments", ["adjustable_id"], :name => "index_adjustments_on_order_id"
  add_index "spree_adjustments", ["source_type", "source_id"], :name => "index_spree_adjustments_on_source_type_and_source_id"

  create_table "spree_assets", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    :limit => 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
    t.integer  "site_id"
  end

  add_index "spree_assets", ["viewable_id"], :name => "index_assets_on_viewable_id"
  add_index "spree_assets", ["viewable_type", "type"], :name => "index_assets_on_viewable_type_and_type"

  create_table "spree_calculators", :force => true do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "spree_cities", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.integer "state_id"
  end

  create_table "spree_configurations", :force => true do |t|
    t.string   "name"
    t.string   "type",       :limit => 50
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "site_id"
  end

  add_index "spree_configurations", ["name", "type"], :name => "index_spree_configurations_on_name_and_type"

  create_table "spree_countries", :force => true do |t|
    t.string  "iso_name"
    t.string  "iso"
    t.string  "iso3"
    t.string  "name"
    t.integer "numcode"
    t.boolean "states_required", :default => false
  end

  create_table "spree_credit_cards", :force => true do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "last_digits"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "address_id"
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "spree_customizable_product_options", :force => true do |t|
    t.integer  "product_customization_type_id"
    t.integer  "position"
    t.string   "presentation",                  :null => false
    t.string   "name",                          :null => false
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_customized_product_options", :force => true do |t|
    t.integer  "product_customization_id"
    t.integer  "customizable_product_option_id"
    t.string   "value"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "customization_image"
  end

  create_table "spree_editors", :force => true do |t|
    t.string   "slug",       :limit => 200, :default => "", :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "spree_excluded_ad_hoc_option_values", :force => true do |t|
    t.integer "ad_hoc_variant_exclusion_id"
    t.integer "ad_hoc_option_value_id"
  end

  create_table "spree_gateways", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.string   "server",      :default => "test"
    t.boolean  "test_mode",   :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "spree_html_attributes", :force => true do |t|
    t.string  "title",                      :default => "",    :null => false
    t.string  "css_name",                   :default => "",    :null => false
    t.string  "slug",                       :default => "",    :null => false
    t.string  "pvalues",                    :default => "",    :null => false
    t.string  "pvalues_desc",               :default => "",    :null => false
    t.string  "punits",                     :default => "",    :null => false
    t.boolean "neg_ok",                     :default => false, :null => false
    t.integer "default_value", :limit => 2, :default => 0,     :null => false
    t.string  "pvspecial",     :limit => 7, :default => "",    :null => false
  end

  add_index "spree_html_attributes", ["slug"], :name => "index_spree_html_attributes_on_slug", :unique => true

  create_table "spree_inventory_units", :force => true do |t|
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "shipment_id"
    t.integer  "return_authorization_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "pending",                 :default => true
  end

  add_index "spree_inventory_units", ["order_id"], :name => "index_inventory_units_on_order_id"
  add_index "spree_inventory_units", ["shipment_id"], :name => "index_inventory_units_on_shipment_id"
  add_index "spree_inventory_units", ["variant_id"], :name => "index_inventory_units_on_variant_id"

  create_table "spree_line_items", :force => true do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                                      :null => false
    t.decimal  "price",           :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "currency"
    t.decimal  "cost_price",      :precision => 8, :scale => 2
    t.integer  "tax_category_id"
  end

  add_index "spree_line_items", ["order_id"], :name => "index_spree_line_items_on_order_id"
  add_index "spree_line_items", ["variant_id"], :name => "index_spree_line_items_on_variant_id"

  create_table "spree_log_entries", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "site_id"
  end

  create_table "spree_option_types", :force => true do |t|
    t.string   "name",         :limit => 100
    t.string   "presentation", :limit => 100
    t.integer  "position",                    :default => 0, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "site_id"
  end

  create_table "spree_option_types_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "spree_option_values", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_option_values_variants", :id => false, :force => true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], :name => "index_option_values_variants_on_variant_id_and_option_value_id"
  add_index "spree_option_values_variants", ["variant_id"], :name => "index_spree_option_values_variants_on_variant_id"

  create_table "spree_orders", :force => true do |t|
    t.string   "number",               :limit => 32
    t.decimal  "item_total",                         :precision => 10, :scale => 2, :default => 0.0,     :null => false
    t.decimal  "total",                              :precision => 10, :scale => 2, :default => 0.0,     :null => false
    t.string   "state"
    t.decimal  "adjustment_total",                   :precision => 10, :scale => 2, :default => 0.0,     :null => false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                      :precision => 10, :scale => 2, :default => 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
    t.integer  "site_id"
    t.string   "currency"
    t.string   "last_ip_address"
    t.integer  "created_by_id"
    t.string   "channel",                                                           :default => "spree"
  end

  add_index "spree_orders", ["completed_at"], :name => "index_spree_orders_on_completed_at"
  add_index "spree_orders", ["number"], :name => "index_spree_orders_on_number"

  create_table "spree_page_layouts", :force => true do |t|
    t.integer  "site_id",           :limit => 3,   :default => 0
    t.integer  "root_id",           :limit => 3
    t.integer  "parent_id",         :limit => 3
    t.integer  "lft",               :limit => 2,   :default => 0,     :null => false
    t.integer  "rgt",               :limit => 2,   :default => 0,     :null => false
    t.string   "title",             :limit => 200, :default => "",    :null => false
    t.string   "slug",              :limit => 200, :default => "",    :null => false
    t.integer  "section_id",        :limit => 3,   :default => 0
    t.integer  "section_instance",  :limit => 2,   :default => 0,     :null => false
    t.string   "section_context",   :limit => 64,  :default => "",    :null => false
    t.string   "data_source",       :limit => 32,  :default => "",    :null => false
    t.string   "data_filter",       :limit => 32,  :default => "",    :null => false
    t.boolean  "is_enabled",                       :default => true,  :null => false
    t.integer  "copy_from_root_id",                :default => 0,     :null => false
    t.boolean  "is_full_html",                     :default => false, :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "data_source_param",                :default => ""
    t.integer  "content_param",                    :default => 0,     :null => false
  end

  create_table "spree_param_categories", :force => true do |t|
    t.integer  "editor_id",  :limit => 3,   :default => 0,    :null => false
    t.integer  "position",   :limit => 3,   :default => 0
    t.string   "slug",       :limit => 200, :default => "",   :null => false
    t.boolean  "is_enabled",                :default => true, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "spree_param_values", :force => true do |t|
    t.integer  "page_layout_root_id", :limit => 2,    :default => 0, :null => false
    t.integer  "page_layout_id",      :limit => 2,    :default => 0, :null => false
    t.integer  "section_param_id",    :limit => 2,    :default => 0, :null => false
    t.integer  "theme_id",            :limit => 2,    :default => 0, :null => false
    t.string   "pvalue",              :limit => 4096
    t.string   "unset"
    t.string   "computed_pvalue"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "spree_payment_methods", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.datetime "deleted_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "display_on"
    t.integer  "site_id"
  end

  create_table "spree_payments", :force => true do |t|
    t.decimal  "amount",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.string   "identifier"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
  end

  add_index "spree_payments", ["order_id"], :name => "index_spree_payments_on_order_id"

  create_table "spree_post_products", :force => true do |t|
    t.integer "post_id"
    t.integer "product_id"
    t.integer "position"
  end

  create_table "spree_posts", :force => true do |t|
    t.integer  "site_id",            :default => 0
    t.string   "title"
    t.string   "permalink"
    t.string   "teaser"
    t.datetime "posted_at"
    t.text     "body"
    t.string   "author"
    t.boolean  "live",               :default => true
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "position",           :default => 0
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size",    :default => 0
    t.datetime "cover_updated_at"
  end

  create_table "spree_posts_taxons", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "taxon_id"
  end

  create_table "spree_preferences", :force => true do |t|
    t.text     "value"
    t.string   "key"
    t.string   "value_type"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "site_id",    :default => 0
  end

  add_index "spree_preferences", ["site_id", "key"], :name => "index_spree_preferences_on_key", :unique => true

  create_table "spree_prices", :force => true do |t|
    t.integer "variant_id",                               :null => false
    t.decimal "amount",     :precision => 8, :scale => 2
    t.string  "currency"
  end

  add_index "spree_prices", ["variant_id", "currency"], :name => "index_spree_prices_on_variant_id_and_currency"

  create_table "spree_product_customization_types", :force => true do |t|
    t.string   "name"
    t.string   "presentation"
    t.string   "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "spree_product_customization_types_products", :id => false, :force => true do |t|
    t.integer "product_customization_type_id"
    t.integer "product_id"
  end

  create_table "spree_product_customizations", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "product_customization_type_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_product_option_types", :force => true do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_product_properties", :force => true do |t|
    t.string   "value"
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "position",    :default => 0
  end

  add_index "spree_product_properties", ["product_id"], :name => "index_product_properties_on_product_id"

  create_table "spree_products", :force => true do |t|
    t.string   "name",                 :default => "", :null => false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "permalink"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "site_id"
    t.integer  "theme_id",             :default => 0,  :null => false
  end

  add_index "spree_products", ["available_on"], :name => "index_spree_products_on_available_on"
  add_index "spree_products", ["deleted_at"], :name => "index_spree_products_on_deleted_at"
  add_index "spree_products", ["name"], :name => "index_spree_products_on_name"
  add_index "spree_products", ["permalink"], :name => "index_spree_products_on_permalink"
  add_index "spree_products", ["site_id", "permalink"], :name => "permalink_idx_unique", :unique => true

  create_table "spree_products_global_taxons", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
  end

  add_index "spree_products_global_taxons", ["product_id"], :name => "index_spree_products_global_taxons_on_product_id"
  add_index "spree_products_global_taxons", ["taxon_id"], :name => "index_spree_products_global_taxons_on_taxon_id"

  create_table "spree_products_promotion_rules", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], :name => "index_products_promotion_rules_on_product_id"
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], :name => "index_products_promotion_rules_on_promotion_rule_id"

  create_table "spree_products_taxons", :force => true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
  end

  add_index "spree_products_taxons", ["product_id"], :name => "index_spree_products_taxons_on_product_id"
  add_index "spree_products_taxons", ["taxon_id"], :name => "index_spree_products_taxons_on_taxon_id"

  create_table "spree_promotion_action_line_items", :force => true do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            :default => 1
  end

  create_table "spree_promotion_actions", :force => true do |t|
    t.integer "activator_id"
    t.integer "position"
    t.string  "type"
  end

  create_table "spree_promotion_rules", :force => true do |t|
    t.integer  "activator_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_promotion_rules", ["product_group_id"], :name => "index_promotion_rules_on_product_group_id"
  add_index "spree_promotion_rules", ["user_id"], :name => "index_promotion_rules_on_user_id"

  create_table "spree_promotion_rules_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], :name => "index_promotion_rules_users_on_promotion_rule_id"
  add_index "spree_promotion_rules_users", ["user_id"], :name => "index_promotion_rules_users_on_user_id"

  create_table "spree_properties", :force => true do |t|
    t.string   "name"
    t.string   "presentation", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "site_id"
  end

  create_table "spree_properties_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "spree_prototypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "site_id"
  end

  create_table "spree_return_authorizations", :force => true do |t|
    t.string   "number"
    t.string   "state"
    t.decimal  "amount",            :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.text     "reason"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "stock_location_id"
  end

  create_table "spree_roles", :force => true do |t|
    t.string "name"
  end

  create_table "spree_roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], :name => "index_spree_roles_users_on_role_id"
  add_index "spree_roles_users", ["user_id"], :name => "index_spree_roles_users_on_user_id"

  create_table "spree_section_params", :force => true do |t|
    t.integer  "section_root_id"
    t.integer  "section_id"
    t.integer  "section_piece_param_id"
    t.string   "default_value"
    t.boolean  "is_enabled",             :default => true
    t.string   "disabled_ha_ids",        :default => "",   :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "spree_section_piece_params", :force => true do |t|
    t.integer "section_piece_id",   :limit => 2,    :default => 0,    :null => false
    t.integer "editor_id",          :limit => 2,    :default => 0,    :null => false
    t.integer "param_category_id",  :limit => 2,    :default => 0,    :null => false
    t.integer "position",           :limit => 2,    :default => 0,    :null => false
    t.string  "pclass"
    t.string  "class_name",                         :default => "",   :null => false
    t.string  "html_attribute_ids", :limit => 1000, :default => "",   :null => false
    t.string  "param_conditions",   :limit => 1000
    t.boolean "is_editable",                        :default => true
    t.string  "editable_condition",                 :default => ""
  end

  create_table "spree_section_pieces", :force => true do |t|
    t.string   "title",         :limit => 100,                      :null => false
    t.string   "slug",          :limit => 100,                      :null => false
    t.string   "html",          :limit => 12000, :default => "",    :null => false
    t.string   "css",           :limit => 8000,  :default => "",    :null => false
    t.string   "js",            :limit => 60,    :default => "",    :null => false
    t.boolean  "is_root",                        :default => false, :null => false
    t.boolean  "is_container",                   :default => false, :null => false
    t.boolean  "is_selectable",                  :default => false, :null => false
    t.string   "resources",     :limit => 20,    :default => "",    :null => false
    t.string   "usage",         :limit => 10,    :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_clickable",                   :default => false, :null => false
  end

  add_index "spree_section_pieces", ["slug"], :name => "index_spree_section_pieces_on_slug", :unique => true

  create_table "spree_section_texts", :force => true do |t|
    t.string   "lang"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_sections", :force => true do |t|
    t.integer "site_id",                  :limit => 3,   :default => 0,    :null => false
    t.integer "root_id",                  :limit => 3
    t.integer "parent_id",                :limit => 3
    t.integer "lft",                      :limit => 2,   :default => 0,    :null => false
    t.integer "rgt",                      :limit => 2,   :default => 0,    :null => false
    t.string  "title",                    :limit => 64,  :default => "",   :null => false
    t.string  "slug",                     :limit => 64,  :default => "",   :null => false
    t.integer "section_piece_id",         :limit => 3,   :default => 0
    t.integer "section_piece_instance",   :limit => 2,   :default => 0
    t.boolean "is_enabled",                              :default => true, :null => false
    t.string  "global_events",            :limit => 200, :default => "",   :null => false
    t.string  "subscribed_global_events", :limit => 200, :default => "",   :null => false
    t.integer "content_param",                           :default => 0,    :null => false
  end

  create_table "spree_shipments", :force => true do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",              :precision => 8, :scale => 2
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "address_id"
    t.string   "state"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "stock_location_id"
  end

  add_index "spree_shipments", ["number"], :name => "index_shipments_on_number"
  add_index "spree_shipments", ["order_id"], :name => "index_spree_shipments_on_order_id"

  create_table "spree_shipping_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "site_id"
  end

  create_table "spree_shipping_method_categories", :force => true do |t|
    t.integer  "shipping_method_id",   :null => false
    t.integer  "shipping_category_id", :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "spree_shipping_method_categories", ["shipping_category_id"], :name => "index_spree_shipping_method_categories_on_shipping_category_id"
  add_index "spree_shipping_method_categories", ["shipping_method_id"], :name => "index_spree_shipping_method_categories_on_shipping_method_id"

  create_table "spree_shipping_methods", :force => true do |t|
    t.string   "name"
    t.string   "display_on"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "site_id"
    t.string   "tracking_url"
    t.string   "admin_name"
  end

  create_table "spree_shipping_methods_zones", :id => false, :force => true do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
  end

  create_table "spree_shipping_rates", :force => true do |t|
    t.integer  "shipment_id"
    t.integer  "shipping_method_id"
    t.boolean  "selected",                                         :default => false
    t.decimal  "cost",               :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  add_index "spree_shipping_rates", ["shipment_id", "shipping_method_id"], :name => "spree_shipping_rates_join_index", :unique => true

  create_table "spree_sites", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "layout"
    t.integer  "parent_id"
    t.string   "short_name"
    t.integer  "rgt"
    t.integer  "lft"
    t.boolean  "has_sample",          :default => false
    t.boolean  "loading_sample",      :default => false
    t.integer  "index_page",          :default => 0
    t.integer  "theme_id",            :default => 0
    t.integer  "template_release_id", :default => 0
    t.integer  "foreign_theme_id",    :default => 0,     :null => false
  end

  create_table "spree_state_changes", :force => true do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.string   "stateful_type"
    t.string   "next_state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "site_id"
  end

  create_table "spree_states", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.integer "country_id"
  end

  create_table "spree_stock_items", :force => true do |t|
    t.integer  "stock_location_id"
    t.integer  "variant_id"
    t.integer  "count_on_hand",     :default => 0,     :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "backorderable",     :default => false
    t.datetime "deleted_at"
  end

  add_index "spree_stock_items", ["stock_location_id", "variant_id"], :name => "stock_item_by_loc_and_var_id"
  add_index "spree_stock_items", ["stock_location_id"], :name => "index_spree_stock_items_on_stock_location_id"

  create_table "spree_stock_locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "state_name"
    t.integer  "country_id"
    t.string   "zipcode"
    t.string   "phone"
    t.boolean  "active",                 :default => true
    t.boolean  "backorderable_default",  :default => false
    t.boolean  "propagate_all_variants", :default => true
    t.string   "admin_name"
  end

  create_table "spree_stock_movements", :force => true do |t|
    t.integer  "stock_item_id"
    t.integer  "quantity",        :default => 0
    t.string   "action"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "originator_id"
    t.string   "originator_type"
  end

  add_index "spree_stock_movements", ["stock_item_id"], :name => "index_spree_stock_movements_on_stock_item_id"

  create_table "spree_stock_transfers", :force => true do |t|
    t.string   "type"
    t.string   "reference"
    t.integer  "source_location_id"
    t.integer  "destination_location_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "number"
  end

  add_index "spree_stock_transfers", ["destination_location_id"], :name => "index_spree_stock_transfers_on_destination_location_id"
  add_index "spree_stock_transfers", ["number"], :name => "index_spree_stock_transfers_on_number"
  add_index "spree_stock_transfers", ["source_location_id"], :name => "index_spree_stock_transfers_on_source_location_id"

  create_table "spree_tax_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_default",  :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "site_id"
  end

  create_table "spree_tax_rates", :force => true do |t|
    t.decimal  "amount",             :precision => 8, :scale => 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.boolean  "included_in_price",                                :default => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "name"
    t.boolean  "show_rate_in_label",                               :default => true
    t.datetime "deleted_at"
  end

  create_table "spree_taxonomies", :force => true do |t|
    t.string   "name",                      :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "site_id"
    t.integer  "position",   :default => 0
  end

  create_table "spree_taxons", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position",          :default => 0
    t.string   "name",                                :null => false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "site_id"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "depth"
    t.integer  "page_context",      :default => 0,    :null => false
    t.string   "html_attributes"
    t.integer  "replaced_by",       :default => 0,    :null => false
    t.boolean  "is_clickable",      :default => true, :null => false
  end

  add_index "spree_taxons", ["parent_id"], :name => "index_taxons_on_parent_id"
  add_index "spree_taxons", ["permalink"], :name => "index_taxons_on_permalink"
  add_index "spree_taxons", ["taxonomy_id"], :name => "index_taxons_on_taxonomy_id"

  create_table "spree_template_files", :force => true do |t|
    t.integer  "theme_id"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
  end

  create_table "spree_template_releases", :force => true do |t|
    t.string   "name",       :limit => 24,                :null => false
    t.integer  "theme_id",                 :default => 0, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "spree_template_texts", :force => true do |t|
    t.integer  "site_id",    :default => 0, :null => false
    t.string   "name"
    t.text     "body"
    t.string   "permalink"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "spree_template_texts", ["permalink"], :name => "index_spree_template_texts_on_slug"

  create_table "spree_template_themes", :force => true do |t|
    t.integer  "site_id",                               :default => 0
    t.integer  "page_layout_root_id",                   :default => 0,     :null => false
    t.integer  "release_id",                            :default => 0
    t.string   "title",                 :limit => 64,   :default => "",    :null => false
    t.string   "slug",                  :limit => 64,   :default => "",    :null => false
    t.string   "assigned_resource_ids", :limit => 1024, :default => "",    :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.boolean  "is_public",                             :default => false, :null => false
  end

  create_table "spree_tokenized_permissions", :force => true do |t|
    t.integer  "permissable_id"
    t.string   "permissable_type"
    t.string   "token"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_tokenized_permissions", ["permissable_id", "permissable_type"], :name => "index_tokenized_name_and_type"

  create_table "spree_trackers", :force => true do |t|
    t.string   "environment"
    t.string   "analytics_id"
    t.boolean  "active",       :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "site_id"
  end

  create_table "spree_users", :force => true do |t|
    t.string   "encrypted_password",     :limit => 128
    t.string   "password_salt",          :limit => 128
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                         :default => 0, :null => false
    t.integer  "failed_attempts",                       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "site_id"
    t.datetime "remember_created_at"
    t.string   "spree_api_key",          :limit => 48
  end

  add_index "spree_users", ["site_id", "email"], :name => "email_idx_unique", :unique => true
  add_index "spree_users", ["spree_api_key"], :name => "index_spree_users_on_spree_api_key"

  create_table "spree_variants", :force => true do |t|
    t.string   "sku",                                           :default => "",    :null => false
    t.decimal  "weight",          :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "height",          :precision => 8, :scale => 2
    t.decimal  "width",           :precision => 8, :scale => 2
    t.decimal  "depth",           :precision => 8, :scale => 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                     :default => false
    t.integer  "product_id"
    t.decimal  "cost_price",      :precision => 8, :scale => 2
    t.string   "cost_currency"
    t.integer  "position"
    t.boolean  "track_inventory",                               :default => true
  end

  add_index "spree_variants", ["product_id"], :name => "index_spree_variants_on_product_id"
  add_index "spree_variants", ["sku"], :name => "index_spree_variants_on_sku"

  create_table "spree_zone_members", :force => true do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "spree_zones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        :default => false
    t.integer  "zone_members_count", :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "site_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "taggings_id_type_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
