Spree::Product.class_eval do
  # Finds all products that have the ids matching the given collection of ids.
  add_search_scope :without_ids do |*ids|
    where.not(id: ids)
  end

  # add_simple_scopes [:ascend_by_created_at, :descend_by_created_at]
  # get newer products of site
  whitelisted_ransackable_attributes << 'created_at'


  scope :for_template, ->{ where.not( theme_id: 0 ) }
  # theme_id could not be null in db
  # in Rails 4.2.5
  # product.update_attributes( theme_id: '' ), sql is theme_id=NULL
  before_validation :fix_attributes

  # refer to https://github.com/AgilTec/spree_variant_options
  def option_values
    @_option_values ||= Spree::OptionValue.for_product(self)
  end

  def grouped_option_values
    @_grouped_option_values ||= option_values.group_by(&:option_type)
    @_grouped_option_values.sort_by { |option_type, option_values| option_type.position }.reverse
  end

  def variants_for_option_value(value)
    @_variant_option_values ||= variants.includes(:option_values)
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

  private
  def fix_attributes
    unless theme_id.kind_of?( Fixnum )
      self.theme_id = theme_id.to_i
    end
  end
end
