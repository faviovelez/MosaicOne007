class Service < ActiveRecord::Base
  belongs_to :sat_key
  belongs_to :sat_unit_key
  belongs_to :store
  belongs_to :business_unit
  has_many :service_offereds
  has_many :services_tickets
  has_many :service_sales
  has_many :tickets, through: :services_tickets

  validates :unique_code, uniqueness: { message: "El código de servicio no se puede repetir, ya existe un servicio con con este código." }

  validates :sat_key_id, presence: { message: "Debe elegir una clave del SAT."}

  validates :sat_unit_key_id, presence: { message: "Debe elegir una clave de unidad del SAT."}

  after_create :save_web_id

  after_save :create_update_change_table

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

  def save_web_id
    self.update(web_id: self.id)
  end

end
