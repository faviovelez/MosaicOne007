class BillingAddress < ActiveRecord::Base
  # Este modelo debe guardar todas las entradas de datos de facturación de prospects o stores
  has_many :prospects
  has_many :business_units
  has_many :bills
  has_many :issuing_companies, foreign_key: 'issuing_company_id'
  has_many :receiving_companies, foreign_key: 'receiving_company_id'
  belongs_to :tax_regime
  belongs_to :store

  validates :business_name, presence: { message: 'Debe escribir la razón social.'}

  validates :rfc, presence: { message: 'Debe escribir el RFC.'}

  after_create :save_web_id_and_set_web_true

  after_save :create_update_change_table

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
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

#  validates :street, presence: { message: 'Debe escribir la calle.'}

#  validates :exterior_number, presence: { message: 'Debe escribir el número exterior.'}

#  validates :neighborhood, presence: { message: 'Debe escribir la colonia.'}

#  validates :city, presence: { message: 'Debe escribir la ciudad.'}

#  validates :state, presence: { message: 'Debe escribir el estado.'}

#  validates :country, presence: { message: 'Debe seleccionar el país.'}

#  validates :rfc, length: { maximum: 13, message: 'El RFC no puede contener más de 13 caracteres.'}

#  validates :zipcode, length: { is: 5, message: 'El código postal debe contener 5 caracteres.'}

#  validates :zipcode, presence: { message: 'Por favor anote el código postal.'}
end
