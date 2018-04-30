class StoreMovement < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  belongs_to :ticket
  belongs_to :store
  belongs_to :return_ticket
  belongs_to :change_ticket
  belongs_to :tax
  belongs_to :supplier
  belongs_to :product_request
  belongs_to :ticket
  has_many :stores_warehouse_entries
  belongs_to :bill
  belongs_to :prospect

  before_update :create_update_summary

  after_create :save_web_id

  after_create :update_web_true

  def save_web_id
    self.update(web_id: self.id)
  end

  def update_web_true
    self.update(web: true)
  end

  def create_update_summary
    unless prospect == nil
      if dont_exist_prospect_sale
        create_prospect_report
      else
        update_prospect_report
      end
    end
    if dont_exist_store_sale
      create_store_report
    else
      update_store_report
    end
    if dont_exist_business_unit_sale
      create_business_unit_report
    else
      update_business_unit_report
    end
    if dont_exist_business_group_sale
      create_business_group_report
    else
      update_business_group_report
    end
    if dont_exist_product_sale
      create_product_report
    else
      update_product_report
    end
  end

  def dont_exist_product_sale
    !!(ProductSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store, product: product).first.nil?)
  end

  def dont_exist_prospect_sale
    !!(ProspectSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store, prospect: prospect).first.nil?)
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store).first.nil?)
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store).first.nil?)
  end

  def dont_exist_business_unit_sale
    !!(BusinessUnitSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, business_unit: self.store.business_unit).first.nil?)
  end

  def dont_exist_business_group_sale
    !!(BusinessGroupSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, business_group: self.store.business_unit.business_group).first.nil?)
  end

  def create_business_group_report
    create_reports_data(
      BusinessGroupSale
    ).update(
      business_group: self.store.business_unit.business_group
    )
  end

  def create_business_unit_report
    create_reports_data(
      BusinessUnitSale
    ).update(
      business_unit: self.store.business_unit
    )
  end

  def create_store_report
    create_reports_data(
      StoreSale
    ).update(
      store: store
    )
  end

  def create_product_report
    create_reports_data(
      ProductSale
    ).update(
      product: product, store: store
    )
  end

  def create_prospect_report
    create_reports_data(
      ProspectSale
    ).update(
      prospect: prospect
    )
  end

  def update_business_group_report
    update_reports_data(
      BusinessGroupSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, business_group: self.store.business_unit.business_group).first
    )
  end

  def update_business_unit_report
    update_reports_data(
      BusinessUnitSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, business_unit: self.store.business_unit).first
    )
  end

  def update_store_report
    update_reports_data(
      StoreSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store).first
    )
  end

  def update_prospect_report
    update_reports_data(
      ProspectSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, prospect: prospect, store: store).first
    )
  end

  def update_product_report
    update_reports_data(
      ProductSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, product: product, store: store).first
    )
  end

  def update_reports_data(object)
    subtotal = self.subtotal.to_f
    discount = self.discount_applied.to_f
    taxes = self.taxes.to_f
    total = self.total.to_f
    quantity = self.quantity.to_i
    cost = self.total_cost.to_f
    if id_changed?
      if self.movement_type == 'venta'
        object.update_attributes(
          subtotal: object.subtotal.to_f + subtotal,
          discount: object.discount.to_f + discount,
          taxes: object.taxes.to_f + taxes,
          total: object.total.to_f + total,
          cost: object.cost.to_f + cost,
          quantity: object.quantity.to_i + quantity,
        )
      elsif self.movement_type == 'devolución'
        object.update_attributes(
          subtotal: object.subtotal.to_f - subtotal,
          discount: object.discount.to_f - discount,
          taxes: object.taxes.to_f - taxes,
          total: object.total.to_f - total,
          cost: object.cost.to_f - cost,
          quantity: object.quantity.to_i - quantity,
        )
      end
      object
    elsif !id_changed? && changes['movement_type'] != nil
      if (changes['movement_type'][0] == 'venta' && self.movement_type == 'cancelado')
        object.update_attributes(
          subtotal: object.subtotal.to_f - subtotal,
          discount: object.discount.to_f - discount,
          taxes: object.taxes.to_f - taxes,
          total: object.total.to_f - total,
          cost: object.cost.to_f - cost,
          quantity: object.quantity.to_i - quantity,
        )
      elsif (changes['movement_type'][0] == 'devolución' && self.movement_type == 'cancelado')
        object.update_attributes(
          subtotal: object.subtotal.to_f + subtotal,
          discount: object.discount.to_f + discount,
          taxes: object.taxes.to_f + taxes,
          total: object.total.to_f + total,
          cost: object.cost.to_f + cost,
          quantity: object.quantity.to_i + quantity,
        )
      end
    end
  end

  def create_reports_data(object)
    subtotal = self.subtotal
    discount = self.discount_applied
    taxes = self.taxes
    total = self.total
    quantity = self.quantity.to_i
    cost = self.total_cost
    month = self.created_at.to_date.month
    year  = self.created_at.to_date.year
    store =  self.store
    if id_changed?
      if self.movement_type == 'venta'
        object.create(
          subtotal: subtotal,
          discount: discount,
          taxes: taxes,
          total: total,
          cost: cost,
          quantity: quantity,
          month: month,
          year: year
        )
      elsif self.movement_type == 'devolución'
        object.create(
          subtotal: - subtotal,
          discount: - discount,
          taxes: - taxes,
          total: - total,
          cost: - cost,
          quantity: - quantity,
          month: month,
          year: year
        )
      end
    elsif (!id_changed? && changes['movement_type'] != nil)
      if (changes['movement_type'][0] == 'venta' && self.movement_type == 'cancelado')
        object.create(
          subtotal: - subtotal,
          discount: - discount,
          taxes: - taxes,
          total: - total,
          cost: - cost,
          quantity: - quantity,
          month: month,
          year: year
        )
      elsif (changes['movement_type'][0] == 'devolución' && self.movement_type == 'cancelado')
        object.create(
          subtotal: subtotal,
          discount: discount,
          taxes: taxes,
          total: total,
          cost: cost,
          quantity: quantity,
          month: month,
          year: year
        )
      end
    else
      object.create(
        subtotal: subtotal,
        discount: discount,
        taxes: taxes,
        total: total,
        cost: cost,
        quantity: quantity,
        month: month,
        year: year
      )      
    end
  end

end
