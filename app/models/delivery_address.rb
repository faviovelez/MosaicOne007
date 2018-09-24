class DeliveryAddress < ActiveRecord::Base
  # Este modelo debe guardar todas las direcciones de entrega.
  has_many :orders
  has_many :stores
  has_many :prospects
  has_one :carrier
  has_one :warehouse
  has_many :suppliers

#  validates :zipcode, length: { is: 5, message: 'El código postal debe contener 5 caracteres.'}

#  validates :zipcode, presence: { message: 'Por favor anote el código postal.'}

#  validates :street, presence: { message: 'Debe escribir la calle.'}

#  validates :exterior_number, presence: { message: 'Debe escribir el número exterior.'}

#  validates :neighborhood, presence: { message: 'Debe escribir la colonia.'}

#  validates :city, presence: { message: 'Debe escribir la ciudad.'}

#  validates :state, presence: { message: 'Debe escribir el estado.'}

#  validates :country, presence: { message: 'Debe escribir el país.'}

end
