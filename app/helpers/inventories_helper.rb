module InventoriesHelper

  def inventory_alert_store(inventory)
    if (inventory.alert == true && inventory.alert_type == 'bajo')
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif (inventory.alert == true && inventory.alert_type == 'crítico')
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def inventory_alert_corp(inventory)
    if (inventory.alert == true && inventory.alert_type == 'bajo')
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif (inventory.alert == true && inventory.alert_type == 'crítico')
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def quantity(inventory)
    @inventory = inventory.quantity
  end

  def packages(inventory, product)
    @packages = inventory.quantity / product.pieces_per_package
  end

end
