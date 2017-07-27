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
  has_many :prospect_sales
  belongs_to :business_unit

  validates :legal_or_business_name, presence: { message: 'Debe especificar el nombre del prospecto.'}

  validates :prospect_type, presence: { message: 'Debe especificar el giro comercial.'}

  validates :contact_first_name, presence: { message: 'Es necesario especificar por lo menos el primer nombre del contacto.'}

  validates :contact_last_name, presence: { message: 'Es necesario especificar por lo menos el apellido paterno del contacto.'}

  validates :direct_phone, numericality: true

  validates :direct_phone, length: {is: 10, message: 'Por favor anote el número telefónico completo a 10 dígitos (incluyendo clave LADA) solo números.'}

  validates :cell_phone, length: {is: 10, message: 'Por favor anote el celular completo a 10 dígitos sin 044 O 045.'}

end
