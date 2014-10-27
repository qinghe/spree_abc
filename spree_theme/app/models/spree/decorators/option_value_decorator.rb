Spree::OptionValue.class_eval do
  has_one :image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  accepts_nested_attributes_for :image
  # for unknown reason accepts_nested_attributes_for do not enable image_attributes
  attr_accessible :image_attributes      
  scope :for_product, lambda { |product| select("DISTINCT #{table_name}.*").where("spree_option_values_variants.variant_id IN (?)", product.variant_ids).joins(:variants)  }  
  
  before_save :set_viewable
  
  private
  def set_viewable
    if image.present?
      image.viewable_type = 'Spree::OptionValue'
      image.viewable_id = self.id
    end
  end
end


Spree::Product.class_eval do
  def option_values
    @_option_values ||= Spree::OptionValue.for_product(self).order(:position).sort_by {|ov| ov.option_type.position }
  end

  def grouped_option_values
    @_grouped_option_values ||= option_values.group_by(&:option_type)
  end

  def variants_for_option_value(value)
    @_variant_option_values ||= variants.includes(:option_values).all
    @_variant_option_values.select { |i| i.option_value_ids.include?(value.id) }
  end

  # return { option_id=>{ option_value_id=>{ variant_id=>variant } } }
  #
  def variant_options_hash
    return @_variant_options_hash if @_variant_options_hash
    hash = {}
    variants.includes(:option_values).each do |variant|
      variant.option_values.each do |ov|
        otid = ov.option_type_id.to_s
        ovid = ov.id.to_s
        hash[otid] ||= {}
        hash[otid][ovid] ||= {}
        hash[otid][ovid][variant.id.to_s] = variant.to_hash
      end
    end
    @_variant_options_hash = hash
  end
end


Spree::Variant.class_eval do
  
  include ActionView::Helpers::NumberHelper
  
  attr_accessible :option_values
  
  def to_hash
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    { 
      :id    => self.id, 
      :count => self.total_on_hand, 
      :price => self.display_price
    }
  end
    
end