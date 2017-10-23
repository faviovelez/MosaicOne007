module InventoriesHelper

  def inventory_alert(product)
    quantity = rand(1..3)
    if quantity == 1
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif quantity == 2
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def set_inventory(product)
    store = current_user.store
    @inventory = ''
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @inventory = product.stores_inventories.where(store: store).first
    else
      @inventory = product.inventory
    end
    @inventory
  end

  def packages(inventory, product)
    @packages = inventory.quantity / product.pieces_per_package
  end

  def sales_future(product)
    id = product.id
    new_id = id.to_i
    new_id -= 1
    past = TemporalNumber.where(store: current_user.store).first.past_sales
    @past_sale = past[new_id]
    @past_sale
  end

  def sales_past(product)
    id = product.id
    new_id = id.to_i
    new_id -= 1
    future = TemporalNumber.where(store: current_user.store).first.future_sales
    @future_sale = future[new_id]
    @future_sale
  end

end
