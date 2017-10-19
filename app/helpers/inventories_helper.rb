module InventoriesHelper

  def inventory_alert(product)
    if (product.inventory.alert == true && product.inventory.alert_type == 'bajo')
      @label = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif (product.inventory.alert == true && product.inventory.alert_type == 'crítico')
      @label = content_tag(:span, 'crítico', class: 'label label-danger')
    else
      @label = content_tag(:span, 'adecuado', class: 'label label-success')
    end
    @label
  end

  def packages(product)
    @packages = product.inventory.quantity / product.pieces_per_package
  end

end
