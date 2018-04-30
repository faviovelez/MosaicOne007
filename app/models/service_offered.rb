class ServiceOffered < ActiveRecord::Base
  belongs_to :service
  belongs_to :store
  belongs_to :business_unit
  belongs_to :bill
  has_one :delivery_service
  belongs_to :ticket
  belongs_to :tax
  belongs_to :ticket
  belongs_to :prospect

  after_create :save_web_id

  after_create :update_web_true

  before_update :create_update_summary

  def save_web_id
    self.update(web_id: self.id)
  end

  def update_web_true
    self.update(web: true)
  end

  def create_update_summary
    if dont_exist_store_sale
      create_store_report
    else
      update_store_report
    end
  end

  def dont_exist_service_sale
    !!(ServiceSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store, service: self.service).first.nil?)
  end

  def dont_exist_prospect_sale
    !!(ProspectSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: store, prospect: self.prospect).first.nil?)
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

  def create_service_report
    create_reports_data(
      ServiceSale
    ).update(
      service: service, store: store
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

  def update_service_report
    update_reports_data(
      ServiceSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, service: self.service, store: store).first
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
      if self.service_type == 'venta'
        object.update_attributes(
          subtotal: object.subtotal.to_f + subtotal,
          discount: object.discount.to_f + discount,
          taxes: object.taxes.to_f + taxes,
          total: object.total.to_f + total,
          cost: object.cost.to_f + cost,
          quantity: object.quantity.to_i + quantity,
        )
      elsif self.service_type == 'devolución'
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
    elsif (!id_changed? && changes['service_type'] != nil)
      if (changes['service_type'][0] == 'venta' && self.service_type == 'cancelado')
        object.update_attributes(
          subtotal: object.subtotal.to_f - subtotal,
          discount: object.discount.to_f - discount,
          taxes: object.taxes.to_f - taxes,
          total: object.total.to_f - total,
          cost: object.cost.to_f - cost,
          quantity: object.quantity.to_i - quantity,
        )
      elsif (changes['service_type'][0] == 'devolución' && self.service_type == 'cancelado')
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
    if id_changed?
      if self.service_type == 'venta'
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
      elsif self.service_type == 'devolución'
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
    elsif !id_changed? && changes['service_type'] != nil
      if (changes['service_type'][0] == 'venta' && self.service_type == 'cancelado')
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
      elsif (changes['service_type'][0] == 'devolución' && self.service_type == 'cancelado')
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

end
