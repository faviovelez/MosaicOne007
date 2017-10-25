module InventoriesHelper

  def inventory_alert(product)
    set_inventory(product)
    if (@inventory.alert == true && @inventory.alert_type == 'bajo')
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif (@inventory.alert == true && @inventory.alert_type == 'crítico')
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def set_inventory(product)
    @inventory = ''
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @inventory = current_user.store.stores_inventories.find_by_product_id(product)
    else
      @inventory = Inventory.find_by_product_id(product)
    end
    @inventory
  end

  def packages(product)
    set_inventory(product)
    @packages = @inventory.quantity / product.pieces_per_package
    @packages
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
