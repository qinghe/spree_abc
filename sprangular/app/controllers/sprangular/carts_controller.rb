class Sprangular::CartsController < Sprangular::BaseController

  def show
    @order = current_order
    if @order
      render 'spree/api/orders/show'
    else
      not_found
    end
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def add_variant
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(variants: { params[:variant_id]=> params[:quantity]}, ad_hoc_option_value_ids: [],product_customizations: [] )
      current_order.ensure_updated_shipments
      @order = current_order
      render 'spree/api/orders/show'
    else
      invalid_resource!(populator)
    end
  end

  def update_variant
    variant_id = params[:variant_id].to_i

    @order = current_order(create_order_if_necessary: true)

    line_item = @order.line_items.detect { |li| li.variant_id == variant_id }
    data = {
      variant_id: variant_id,
      quantity: params[:quantity]
    }
    data.merge!(id: line_item.id) if line_item
    @order.contents.update_cart(line_items_attributes: { '0' => data })

    render 'spree/api/orders/show'
  end

  def change_variant
    old_variant_id = params[:old_variant_id].to_i
    new_variant_id = params[:new_variant_id].to_i

    @order = current_order(create_order_if_necessary: true)

    existing = @order.line_items.detect { |li| li.variant_id == new_variant_id }
    old = @order.line_items.detect { |li| li.variant_id == old_variant_id }

    if existing
      existing.update(variant_id: new_variant_id, quantity: existing.quantity + old.quantity)
      old.destroy
    else
      old.update(variant_id: new_variant_id)
    end

    @order.reload

    render 'spree/api/orders/show'
  end

  def remove_adjustment
    @order = current_order(create_order_if_necessary: true)
    adjustment = @order.adjustments.where(id: params[:adjustment_id]).first!
    promotion = @order.promotions.where('spree_promotions.id' => adjustment.source.promotion_id).first!
    @order.promotions.delete(promotion)
    adjustment.destroy

    @order.update_totals

    render 'spree/api/orders/show'
  end

  def destroy
    if @order = current_order
      @order.empty!
      @order.state ='cart'
      @order.save!
      render 'spree/api/orders/show'
    else
      not_found
    end
  end
end
