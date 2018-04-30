class StoresInventory < ActiveRecord::Base
  belongs_to :product
  belongs_to :store

#  after_save :update_data_inventory

  after_create :save_web_id

  after_create :update_web_true

  def save_web_id
    self.update(web_id: self.id)
  end

  def update_web_true
    self.update(web: true)
  end

  def update_data_inventory
    unless dont_exist_product_sale
      process_inventory(self)
    end
  end

  def dont_exist_product_sale
    !!(ProductSale.where(month: Date.today.month, year: Date.today.year, store: store, product: product).first.nil?)
  end

  def process_inventory(inventory)
    # Usar una lógica similar para inventories (de diseños de cartón)
    get_desired_inventory(inventory)
    change_alert(inventory, @actual_stock, @desired_inventory, @reorder_quantity, @critical_quantity)
    send_mail_to_alert(inventory)
  end

  def get_desired_inventory(inventory)
    product = inventory.product
    store = inventory.store
    months = store.months_in_inventory
    date = Date.today
    reorder = store.reorder_point / 100
    critical = store.critical_point / 100
    @actual_stock = inventory.quantity

    @desired_inventory = 0
    months.times do
      quantity = ProductSale.where(
        product: product,
        store: store,
        month: date.month,
        year: date.year
      ).first.quantity
      @desired_inventory += quantity
      date -= 1.month
    end
    @reorder_quantity = (@desired_inventory * reorder).to_i
    @critical_quantity = (@desired_inventory * critical).to_i
  end

  def change_alert(inventory, stock, desired, reorder, critical)
    @alert = false
    if (stock <= reorder && stock > critical)
      alert_changed_to_true(inventory)
      inventory.update(alert: true, alert_type: 'bajo')
    elsif stock <= critical
      alert_changed_to_true(inventory)
      inventory.update(alert: true, alert_type: 'crítico')
    else
      inventory.update(alert: false, alert_type: nil)
    end
  end

  def alert_changed_to_true(inventory)
    @changed = false
    if inventory.alert == false
      @changed = true
    end
    @changed
  end

  def send_mail_to_alert(inventory)
    # if @changed == true
  end


end
