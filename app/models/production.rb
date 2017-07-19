class Production < ActiveRecord::Base
  # Aún no sé si lo mantenga, para todas las órdenes de producción.
  belongs_to :user
  belongs_to :order
end
