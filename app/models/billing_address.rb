class BillingAddress < ActiveRecord::Base
  # Este modelo debe guardar todas las entradas de datos de facturación de prospects o stores
  has_many :stores
  has_many :prospects
end
