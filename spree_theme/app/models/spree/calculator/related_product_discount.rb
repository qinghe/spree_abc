module Spree
  class Calculator::RelatedProductDiscount < Spree::Calculator
    def self.description
      Spree.t(:related_product_discount)
    end

    def compute(object)
      if object.is_a?(Array)
        return if object.empty?
        order = object.first.order
      else
        order = object
      end

      return unless eligible?(order)
      total = order.line_items.inject(0) do |sum, line_item|
        relations =  Spree::Relation.where(*discount_query(line_item))
        discount_applies_to = relations.map {|rel| rel.related_to.master }

        order.line_items.each do |li|
          next unless discount_applies_to.include? li.variant
          discount = relations.detect { |rel| rel.related_to.master == li.variant }.discount_amount
          sum +=  if li.quantity < line_item.quantity
                    (discount * li.quantity)
                  else
                    (discount * line_item.quantity)
                  end
        end

        sum
      end

      total
    end

    def eligible?(order)
      order.line_items.any? do |line_item|
        Spree::Relation.exists?(discount_query(line_item))
      end
    end

    def discount_query(line_item)
      [
        'discount_amount <> 0.0 AND relatable_type = ? AND relatable_id = ?',
        'Spree::Product',
        line_item.variant.product.id
      ]
    end
  end
end
