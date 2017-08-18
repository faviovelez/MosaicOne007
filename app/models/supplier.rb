class Supplier < ActiveRecord::Base
  has_many :bill_receiveds
  has_many :payments
  has_many :movements
  has_many :pending_movements
  has_many :business_groups, through: :business_groups_suppliers
  has_many :business_groups_suppliers
  belongs_to :delivery_address
  belongs_to :store

  validates :name, presence: { message: 'Debe especificar el nombre del proveedor.'}

  validates :business_type, presence: { message: 'Debe especificar el giro comercial.'}

  validates :contact_first_name, presence: { message: 'Es necesario especificar por lo menos el primer nombre del proveedor.'}

  validates :contact_last_name, presence: { message: 'Es necesario especificar por lo menos el apellido paterno del proveedor.'}

  validates :direct_phone, numericality: true

  validates :direct_phone, length: {is: 10, message: 'Por favor anote el número telefónico completo a 10 dígitos (incluyendo clave LADA) solo números.'}

  validates :cell_phone, length: {is: 10, message: 'Por favor anote el celular completo a 10 dígitos sin 044 O 045.'}

end
