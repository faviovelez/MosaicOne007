class Prospect < ActiveRecord::Base
  # Para todos los clientes o posibles clientes de cada tienda o del corporativo.
  belongs_to :store
  has_many :requests
  belongs_to :billing_address
  belongs_to :delivery_address
  belongs_to :user
  has_many :orders
  has_many :movements
  has_many :pending_movements
  has_many :service_offereds
  has_many :store_movements
  has_many :prospect_sales
  has_many :bills
  belongs_to :store
  belongs_to :business_unit
  belongs_to :business_group
  belongs_to :store_type
  belongs_to :store_prospect, class_name: "Store", foreign_key: 'store_prospect_id'
  has_many :tickets
  has_many :estimate_docs
  has_many :date_advises
  has_many :payments, through: :tickets

  after_create :save_web_id

#  after_save :create_update_change_table

  after_create :update_web_true

  def update_web_true
    self.update(web: true)
  end

  def save_web_id
    self.update(web_id: self.id)
  end

  def first_purchase
    date = self.tickets&.order(:created_at).pluck(:created_at).first&.to_date
    if date == nil
      return 'Sin compras'
    else
      return date
    end
  end

  def last_purchase
    date = self.tickets&.order(created_at: :desc).pluck(:created_at).first&.to_date
    if date == nil
      return 'Sin compras'
    else
      return date
    end
  end

  def sales_number
    self.tickets.where(ticket_type: 'venta').count
  end

  def average_sale
    if (total_sales / sales_number).nan?
      return 0
    else
      return (total_sales / sales_number).round(2)
    end
  end

  def total_sales
    return self.store_movements.where(movement_type: 'venta').sum(:total) - self.store_movements.where(movement_type: 'devolución').sum(:total) + self.service_offereds.where(service_type: 'venta').sum(:total) - self.service_offereds.where(service_type: 'devolución').sum(:total)
  end

  def total_discounts
    return self.store_movements.where(movement_type: 'venta').sum(:discount_applied) - self.store_movements.where(movement_type: 'devolución').sum(:discount_applied) + self.service_offereds.where(service_type: 'venta').sum(:discount_applied) - self.service_offereds.where(service_type: 'devolución').sum(:discount_applied)
  end

  def total_units
    return self.store_movements.where(movement_type: 'venta').sum(:quantity) - self.store_movements.where(movement_type: 'devolución').sum(:quantity) + self.service_offereds.where(service_type: 'venta').sum(:quantity) - self.service_offereds.where(service_type: 'devolución').sum(:quantity)
  end

  def total_payments
    return self.payments.where(payment_type: 'pago').sum(:total) - self.payments.where(payment_type: 'devolución').sum(:total)
  end

  def balance
    return total_sales - total_payments
  end

  def create_update_change_table
    if change_table_dont_exists
      create_change_to_table
    else
      update_change_to_table
    end
  end

  def create_change_to_table
    ChangesToTable.create(table: self.class.name.downcase.pluralize, web_id: self.id, date: Date.today)
  end

  def update_change_to_table
    change_table = ChangesToTable.where(table: self.class.name.downcase.pluralize, web_id: self.id).first
    change_table.update(date: Date.today)
  end

  def change_table_dont_exists
    ChangesToTable.where(table: self.class.name.downcase.pluralize, web_id: self.id) == []
  end


#  validates :legal_or_business_name, presence: { message: 'Debe especificar el nombre del prospecto.'}

#  validates :prospect_type, presence: { message: 'Debe especificar el giro comercial.'}

#  validates :contact_first_name, presence: { message: 'Es necesario especificar por lo menos el primer nombre del contacto.'}

#  validates :contact_last_name, presence: { message: 'Es necesario especificar por lo menos el apellido paterno del contacto.'}

#  validates :direct_phone, numericality: true

#  validates :direct_phone, length: {is: 10, message: 'Por favor anote el número telefónico completo a 10 dígitos (incluyendo clave LADA) solo números.'}

#  validates :cell_phone, length: {is: 10, message: 'Por favor anote el celular completo a 10 dígitos sin 044 O 045.'}

#  Que pida solo un teléfono, o cel o fijo
end
