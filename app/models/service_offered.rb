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

  after_create :create_update_summary

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

  def create_update_summary
    if (self.service_type == 'venta' || self.service_type == 'devolución')
      unless prospect == nil
        if dont_exist_prospect_sale
          create_prospect_report
        else
          update_prospect_report
        end
      end
      if dont_exist_service_sale
        create_service_report
      else
        update_service_report
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
    end
  end

  def dont_exist_service_sale
    !!(ServiceSale.where(month: Date.today.month, year: Date.today.year, store: store, service: self.service).first.nil?)
  end

  def dont_exist_prospect_sale
    !!(ProspectSale.where(month: Date.today.month, year: Date.today.year, store: store, prospect: self.prospect).first.nil?)
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: Date.today.month, year: Date.today.year, store: store).first.nil?)
  end

  def dont_exist_business_unit_sale
    !!(BusinessUnitSale.where(month: Date.today.month, year: Date.today.year, business_unit: self.store.business_unit).first.nil?)
  end

  def dont_exist_business_group_sale
    !!(BusinessGroupSale.where(month: Date.today.month, year: Date.today.year, business_group: self.store.business_unit.business_group).first.nil?)
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
      service: service
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
      BusinessGroupSale.where(month: Date.today.month, year: Date.today.year, business_group: self.store.business_unit.business_group).first
    )
  end

  def update_business_unit_report
    update_reports_data(
      BusinessUnitSale.where(month: Date.today.month, year: Date.today.year, business_unit: self.store.business_unit).first
    )
  end

  def update_store_report
    update_reports_data(
      StoreSale.where(month: Date.today.month, year: Date.today.year, store: store).first
    )
  end

  def update_prospect_report
    update_reports_data(
      ProspectSale.where(month: Date.today.month, year: Date.today.year, prospect: prospect, store: store).first
    )
  end

  def update_service_report
    update_reports_data(
      ServiceSale.where(month: Date.today.month, year: Date.today.year, service: self.service, store: store).first
    )
  end

  def update_reports_data(object)
    subtotal = self.subtotal.to_f
    discount = self.discount_applied.to_f
    taxes = self.taxes.to_f
    total = self.total.to_f
    quantity = self.quantity.to_i
    cost = self.total_cost.to_f
    if self.service_type == 'venta'
      object.update_attributes(
        subtotal: object.subtotal.to_f + subtotal,
        discount: object.discount.to_f + discount,
        taxes: object.taxes.to_f + taxes,
        total: object.total.to_f + total,
        cost: object.cost.to_f + cost,
        quantity: object.quantity.to_i + quantity,
      )
    else
      object.update_attributes(
        subtotal: object.subtotal.to_f - subtotal,
        discount: object.discount.to_f - discount,
        taxes: object.taxes.to_f - taxes,
        total: object.total.to_f - total,
        cost: object.cost.to_f - cost,
        quantity: object.quantity_to_i - quantity,
      )
    end
    object
  end

  def create_reports_data(object)
    subtotal = self.subtotal
    discount = self.discount_applied
    taxes = self.taxes
    total = self.total
    quantity = self.quantity.to_i
    cost = self.total_cost
    month = Date.today.month
    year  = Date.today.year
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
    else
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
  end

end
