module InventoriesHelper

  def inventory_alert(inventory)
    if (inventory.alert == true && @inventory.alert_type == 'bajo')
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif (inventory.alert == true && @inventory.alert_type == 'crítico')
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def alternative_inv_alert(array)
    if (array[8] == true && array[9] == 'bajo')
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif (array[8] == true && array[9] == 'crítico')
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def packages(inventory)
    @packages = inventory.quantity / inventory.product.pieces_per_package
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
