class Request < ActiveRecord::Base
  # Para el formulario de requests (solicitud de pedidos especiales).
  has_many :users, through: :request_users
  has_many :request_users
  belongs_to :prospect
  has_many :documents
  belongs_to :store
  has_many :design_requests
  has_one :order
  belongs_to :product
  belongs_to :estimate_doc

  # Valida que solo se escriban números en el campo de cantidad y que solo sean enteros.
  validates :quantity, on: :create, numericality: { only_integer: true, message: "%{value} No es una cantidad válida, solo se aceptan enteros." }

  # Valida que solo se escriban números en el campo del peso del producto.
  validates :product_weight, numericality: true, allow_nil: true, on: :create

  # Valida que el tipo de diseño siempre se especifique qué tipo de armado se desea (aunque solo se elija la opción que se sugiera).
  validates :design_like, presence: { message: 'Elija el tipo de armado o sugerir armado.', if: :product_type_is_a_box}

  # Valida que el campo de qué medidas se ingresará (externas, internas, etc.) siempre vaya lleno si el tipo de producto es una caja.
  validates :what_measures, presence: { message: 'Debe seleccionar qué medidas ingresará.', if: :product_type_is_a_box}

  # Valida que el costo interno esté presente cuando el manager escriba el precio de venta para la tienda.
  validates :internal_cost, presence: { message: 'Debe incluir costo interno y precio de venta a la tienda', if: :internal_price, on: :update}

  # Valida que la fecha de entrega al cliente sea en el futuro.
  validate :delivery_date_future

  # Valida que se especifique qué producto se cotiza (diferente a caja o bolsa o exhibidor) cuando se selecciona la opción 'otro'
  validate :fill_name_type, on: :create

  # Valida que se especifique la cantidad de productos a cotizar.
  validate :quantity_present, on: :create

  # Valida que siempre que se elija un material, se agrege la resistencia del mismo (o la opción sugerir resistencia)
  validate :material_and_resistance_presence, on: :create

  # Valida que se elija el tipo de producto que se cotiza.
  validate :product_type_presence, on: :create

  # Valida que si se elige bolsa o exhibidor, estén llenos los campos correspondientes a sus medidas.
  validate :outer_inner_bag_or_exhibitor_fields, on: :create

  # Valida que si se elige la opción sugerir resistencia de material, se den todos los datos del producto que contendrá la caja o bolsa.
  validate :resistance_suggestion, on: :create

  # Valida que si se elige la opción sugerir material, se den todos los datos del producto que contendrá la caja o bolsa.
  validate :measures_suggestion, on: :create

  # Valida que si se seleccionó que sí se requiere impresión, todos los campos de este tipo estén llenos.
  validate :impression_fields_complete, if: :impression_selected, on: :create

  # Envía un correo elecrónico notificando que se asignó el costo a su solicitud
  after_update :send_mail_to_store_users_cost, if: :status_changed_to_cost_assigned

  # Envía un correo elecrónico notificando que se asignó el precio de venta a la solicitud
  after_update :send_mail_to_manager_price, if: :status_changed_to_price_assigned

  # Envía un correo elecrónico notificando que la tienda autorizó la solicitud
  after_update :send_mail_to_manager_authorised, if: :status_changed_to_authorised

  # Envía un correo elecrónico notificando que la tienda canceló la solicitud
  after_update :send_mail_to_manager_cancelled, if: :status_changed_to_cancelled

  # Envía un correo elecrónico notificando que la tienda reactivó la solicitud
  after_update :send_mail_to_manager_reactivated, if: :cancelled_request_is_reactivated

  # Si la fecha de entrega existe, validar que no sea en el pasado.
  def delivery_date_future
    if delivery_date.present? && delivery_date < Date.today
      errors[:base] << "La fecha no puede estar en el pasado." unless created_at.to_date < delivery_date
    end
  end

  # Condicional para saber si el producto es una caja
  def product_type_is_a_box
    product_type == 'caja'
  end

  # Validación para que se escriba el producto que se quiere cotizar cuando el cliente elija 'otro' en tipo de producto
  def fill_name_type
    if name_type.blank?
      errors[:base] << "Mencionle el tipo de producto que quiere cotizar." unless product_type != 'otro'
    end
  end

  # Valida que todos los campos del tipo de producto estén llenos o por lo menos toda la descripción del producto que irá dentro de la caja o bolsa.
  def resistance_suggestion
    if (main_material == 'sugerir material' || resistance_main_material == 'Sugerir resistencia')
      unless field_type_complete || product_complete
        errors[:base] << "Para sugerir el material o resistencia, llene todos los campos del producto."
      end
    end
  end

  # Validación para asegurar que se ponga la cantidad a cotizar.
  def quantity_present
    errors[:base] << "Es necesario anotar la cantidad a cotizar." if quantity.blank?
  end

  # Validación para que se pongan la resistencia de cada material elegido (hay 3 pares de campos: material y su resistencia)
  def material_and_resistance_presence
    material_fields = [main_material, secondary_material, third_material]
    resistance_fields = [resistance_main_material, resistance_secondary_material, resistance_third_material]
    n = 0
    t = 1
    if secondary_material.present?
      t +=1
    end
    if third_material.present?
      t +=1
    end
    (t).times do
      unless (material_fields[n].present? && resistance_fields[n].present?)
        errors[:base] << "Seleccione material y resistencia"
      end
      n += 1
    end
  end

  # Validación para que se agregue el tipo de producto
  def product_type_presence
    errors[:base] << "El tipo de producto no puede ir vacío." if product_type.blank?
  end

  # Condición que evalúa si todos los campos de medidas están completos.
  def field_type_complete
    if product_type == 'exhibidor'
      exhibitor_fields = [exhibitor_height, tray_quantity, tray_length, tray_width, tray_divisions]
      exhibitor_fields.all?
    elsif product_type == 'bolsa'
      bag_fields = [bag_length, bag_width, bag_height]
      bag_fields.all?
    elsif product_type == 'caja' || product_type == 'otro'
      outer_fields = [outer_length, outer_width, outer_height]
      inner_fields = [inner_length, inner_width, inner_height]
      outer_fields.all? || inner_fields.all?
    end
  end

  # Validación que evalua si todos los campos del tipo de producto están llenos y despliega el error a menos que los campos del producto que irá dentro estén completos.
  def outer_inner_bag_or_exhibitor_fields
    if product_type == 'exhibidor'
      exhibitor_fields = [exhibitor_height, tray_quantity, tray_length, tray_width, tray_divisions]
      unless exhibitor_fields.all? || product_complete
        errors[:base] << "Es necesario llenar todas las especificaciones del exhibidor."
      end
    elsif product_type == 'bolsa'
      bag_fields = [bag_length, bag_width, bag_height]
      unless bag_fields.all? || product_complete
        errors[:base] << "Es necesario llenar todas las especificaciones de la bolsa."
      end
    elsif product_type == 'caja' || product_type == 'otro'
      outer_fields = [outer_length, outer_width, outer_height]
      inner_fields = [inner_length, inner_width, inner_height]
      unless outer_fields.all? || inner_fields.all? || product_complete
        errors[:base] << "Es necesario llenar todas las medidas o los detalles del producto."
      end
    end
  end

  # Validación que evalúa si los campos de la descripción del producto que irán dentro están completos para poder elegir las opciones de sugerir medidas.
  def measures_suggestion
    if what_measures == 'sugerir medidas'
      errors[:base] << "Es necesario llenar todas las medidas o los detalles del producto." unless product_complete
    end
  end

  # Validación que evalúa campos adicionales (cuántos productos son, si las cajas son para estibar o almacenar) pero sólo si el producto es una caja y se pide sugerir material o resistencia.
  def product_complete
    @product_fields = []
    if resistance_main_material == 'Sugerir resistencia' || main_material == 'sugerir material'
      if product_type == 'caja'
        @product_fields = [product_what, how_many, product_weight, for_what, boxes_stow]
      else
        @product_fields = [product_what, how_many, product_weight]
      end
    @product_fields.all?
    end
  end

  # Validación que evalúa si los campos de impresión están completos al seleccionar que lleva impresión.
  def impression_fields_complete
    impression_fields = [inks, impression_finishing, impression_where]
    errors[:base] << "Es necesario llenar todos los datos de impresión." unless impression_fields.all?
  end

  # Condicional que evalúa si se eligió que sí lleva impresión.
  def impression_selected
    impression == 'si'
  end

  # Envía un correo elecrónico notificando que se asignó el costo a su solicitud
  def send_mail_to_store_users_cost
    if !@sent
      RequestMailer.status_cost_assigned(self).deliver_now
      @sent = true
    end
  end

  # Envía un correo elecrónico notificando que se asignó el precio de venta a la solicitud
  def send_mail_to_manager_price
    if !@sent
      RequestMailer.status_price_assigned(self).deliver_now
      @sent = true
    end
  end

  # Envía un correo elecrónico notificando que la tienda autorizó la solicitud
  def send_mail_to_manager_authorised
    if !@sent
      RequestMailer.status_authorised(self).deliver_now
      @sent = true
    end
  end

  # Envía un correo elecrónico notificando que la tienda canceló la solicitud
  def send_mail_to_manager_cancelled
    if !@sent
      RequestMailer.status_cancelled(self).deliver_now
      @sent = true
    end
  end

  def send_mail_to_manager_reactivated
    if !@sent
      RequestMailer.request_reactivated(self).deliver_now
      @sent = true
    end
  end
  # Valida que se haya hecho una transición de cotizando a costo asignado
  def status_changed_to_cost_assigned
    (status == 'costo asignado' && internal_price.present?)
  end

  # Valida que se haya hecho una transición de costo asignado a precio asignado
  def status_changed_to_price_assigned
    (status == 'precio asignado' && status_was == 'costo asignado' && sales_price.present?)
  end

  # Valida si el estatus cambió a autorizada.
  def status_changed_to_authorised
    (status == 'autorizada' && status_was == 'precio asignado')
  end

  # Valida si el estatus cambió a cancelada.
  def status_changed_to_cancelled
    (status == 'cancelada' && status_was != 'cancelada')
  end

  # Valida si el estatus cambió de cancelada a cualquier otro.
  def cancelled_request_is_reactivated
    (status != 'cancelada' && status_was == 'cancelada')
  end

end
