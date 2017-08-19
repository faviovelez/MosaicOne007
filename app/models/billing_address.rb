class BillingAddress < ActiveRecord::Base
  # Este modelo debe guardar todas las entradas de datos de facturación de prospects o stores
  has_many :prospects
  has_many :business_units
  has_many :stores

  validates :business_name, presence: { message: 'Debe escribir la razón social.'}

  validates :rfc, presence: { message: 'Debe escribir la razón social.'}

  validates :street, presence: { message: 'Debe escribir la calle.'}

  validates :exterior_number, presence: { message: 'Debe escribir el número exterior.'}

  validates :neighborhood, presence: { message: 'Debe escribir la colonia.'}

  validates :city, presence: { message: 'Debe escribir la ciudad.'}

  validates :state, presence: { message: 'Debe escribir el estado.'}

  validates :country, presence: { message: 'Debe escribir el país.'}

  validates :rfc, length: { maximum: 13, message: 'El RFC no puede contener más de 13 caracteres.'}

  validates :zipcode, length: { is: 5, message: 'El código postal debe contener 5 caracteres.'}

  validates :zipcode, presence: { message: 'Por favor anote el código postal.'}

end
