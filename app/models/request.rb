class Request < ActiveRecord::Base
  has_many :users, through: :request_users
  belongs_to :prospect
  has_many :documents
  has_many :modified_fields
  belongs_to :store
  has_many :design_requests
  has_one :order
  has_many :request_users

  validates :quantity, on: :create, numericality: { only_integer: true, message: "%{value} No es una cantidad válida, solo se aceptan enteros." }
  validates :product_weight, numericality: true, allow_nil: true, on: :create
  validates :design_like, presence: { message: 'Elija el tipo de armado o sugerir armado.', unless: :product_type_is_not_box}
  validate :delivery_date_future
  validate :fill_name_type, on: :create
  validate :quantity_present, on: :create
  validate :material_and_resistance_presence, on: :create
  validate :product_type_presence, on: :create
  validate :outer_inner_bag_or_exhibitor_fields, on: :create
  validate :resistance_suggestion, on: :create
  validate :measures_suggestion, on: :create
  validate :impression_fields_complete, if: :impression_selected, on: :create

  def delivery_date_future
    if delivery_date.present? && delivery_date < Date.today
      errors[:base] << "La fecha no puede estar en el pasado."
    end
  end

  def product_type_is_not_box
    product_type != 'caja'
  end

  def fill_name_type
    if name_type.blank?
      errors[:base] << "Mencionle el tipo de producto que quiere cotizar." unless product_type != 'otro'
    end
  end

  def resistance_suggestion
    if (main_material == 'sugerir material' || resistance_main_material == 'Sugerir resistencia')
      unless field_type_complete || product_complete
        errors[:base] << "Para sugerir el material o resistencia, llene todos los campos del producto."
      end
    end
  end

  def quantity_present
    errors[:base] << "Es necesario anotar la cantidad a cotizar." if quantity.blank?
  end

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

  def product_type_presence
    errors[:base] << "El tipo de producto no puede ir vacío." if product_type.blank?
  end

  def field_type_complete
    if product_type == 'exhibidor'
      exhibitor_fields = [exhibitor_height, tray_quantity, tray_length, tray_width, tray_divisions]
      exhibitor_fields.all?
    elsif product_type == 'bolsa'
      bag_fields = [bag_length, bag_width, bag_height]
      bag_fields.all?
    elsif product_type == 'caja' || product_type == 'otro'
      outer_fields = [outer_length, outer_widht, outer_height]
      inner_fields = [inner_length, inner_width, inner_height]
      outer_fields.all? || inner_fields.all?
    end
  end

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
      outer_fields = [outer_length, outer_widht, outer_height]
      inner_fields = [inner_length, inner_width, inner_height]
      unless outer_fields.all? || inner_fields.all? || product_complete
        errors[:base] << "Es necesario llenar todas las medidas o los detalles del producto."
      end
    end
  end

  def measures_suggestion
    if what_measures == 'sugerir medidas'
      errors[:base] << "Es necesario llenar todas las medidas o los detalles del producto." unless product_complete
    end
  end

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

  def impression_fields_complete
    impression_fields = [inks, impression_finishing, impression_where]
    errors[:base] << "Es necesario llenar todos los datos de impresión." unless impression_fields.all?
  end

  def impression_selected
    impression == 'si'
  end

end
