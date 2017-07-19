class Bill < ActiveRecord::Base
  # Este modelo debe contener todo lo relacionado a las facturas
  belongs_to :product
  belongs_to :order
  has_one :additional_discount
end
