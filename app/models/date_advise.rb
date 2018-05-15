class DateAdvise < ActiveRecord::Base
  belongs_to :store
  belongs_to :prospect
  belongs_to :ticket
  belongs_to :order
  belongs_to :payment

  # Crear o modificar objeto y si pertenece al mismo ticket dejar solo uno y borrar los demás (borrar los viejos)
  # Buscar y modificar los que pertenezcan al mismo ticket y desactivarlas y/o borrarlas

end
