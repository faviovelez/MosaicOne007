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

  def create_update_summary
    if dont_exist_prospect_sale
      create_prospect_report
    else
      update_prospect_report
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
  end

  def dont_exist_service_sale
    !!(ServiceSale.where(month: Date.today.month, year: Date.today.year, store: store.id, service: service.id).first.nil?)
  end

  def dont_exist_prospect_sale
    !!(ProspectSale.where(month: Date.today.month, year: Date.today.year, store: store.id, prospect: prospect.id).first.nil?)
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: Date.today.month, year: Date.today.year, store: store.id).first.nil?)
  end

  def create_store_report
    create_reports_data(
      StoreSale
    ).update(
      store_id: store.id
    )
  end

  def create_service_report
    create_reports_data(
      ServiceSale
    ).update(
      service_id: service.id,
    )
  end

  def create_prospect_report
    create_reports_data(
      ProspectSale
    ).update(
      prospect_id: prospect.id
    )
  end

  def update_store_report
    update_reports_data(
      StoreSale.where(month: Date.today.month, year: Date.today.year, store: store).first
    )
  end

  def update_prospect_report
    update_reports_data(
      ProspectSale.where(month: Date.today.month, year: Date.today.year, prospect: prospect.id, store: store.id).first
    )
  end

  def update_service_report
    update_reports_data(
      ServiceSale.where(month: Date.today.month, year: Date.today.year, service: service.id, store: store.id).first
    )
  end

  def update_reports_data(object)
    subtotal = self.subtotal
    discount = self.discount_applied
    taxes = self.taxes
    total = self.total
    quantity = self.quantity
    cost = self.total_cost.to_f
    object.update_attributes(
      subtotal: object.subtotal + subtotal,
      discount: object.discount + discount,
      taxes: object.taxes + taxes,
      total: object.total + total,
      cost: object.cost + cost,
      quantity: object.quantity + quantity,
    )
    object
  end

  def create_reports_data(object)
    subtotal = self.subtotal
    discount = self.discount_applied
    taxes = self.taxes
    total = self.total
    quantity = self.quantity
    cost = self.total_cost.to_f
    month = Date.today.month
    year  = Date.today.year
    store = self.store
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
