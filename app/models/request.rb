class Request < ActiveRecord::Base
  has_many :users, through: :request_users
  belongs_to :prospect
  has_many :documents
  has_many :modified_fields
  belongs_to :store
  has_many :design_requests
  has_one :order
  has_many :request_users

  validates :quantity, numericality: { only_integer: true, message: "%{value} No es una cantidad válida, solo se aceptan enteros." }
  validates :product_weight, numericality: true, allow_nil: true
  validate :fill_name_type
  validate :quantity_present
  validate :material_and_resistance_presence
  validate :product_type_presence
  validate :outer_or_inner_fields, unless: :product_complete
  validate :resistance_sugestion, unless: :product_complete
  validate :measures_suggestion, unless: :product_complete
  validate :impression_fields_complete, if: :impression_selected

  def fill_name_type
    if name_type.blank?
      errors[:base] << "Mencionle el tipo de producto que quiere cotizar." unless product_type != 'otro'
    end
  end

  def resistance_sugestion
    if (resistance_main_material == 'Sugerir resistencia' || main_material == 'sugerir material')
      errors[:base] << "Para sugerir el material o resistencia, llene todos los campos del producto."
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

  def outer_or_inner_fields
    outer_fields = [outer_length, outer_widht, outer_height]
    inner_fields = [inner_length, inner_width, inner_height]
    unless (outer_fields.all? || inner_fields.all?)
      errors[:base] << "Es necesario llenar todas las medidas o los detalles del producto."
    end
  end

  def measures_suggestion
    if what_measures == 'sugerir medidas'
      errors[:base] << "Es necesario llenar todas las medidas o los detalles del producto."
    end
  end

  def product_complete
    product_fields = []
    if ((resistance_main_material == 'Sugerir resistencia' || main_material == 'sugerir material') && product_type == 'caja')
      product_fields = [product_what, how_many, product_length, product_width, product_height, for_what, boxes_stow]
    else
      product_fields = [product_what, how_many, product_length, product_width, product_height]
    end
    product_fields.all?
  end

  def impression_fields_complete
    impression_fields = [inks, impression_finishing, impression_where]
    errors[:base] << "Es necesario llenar todos los datos de impresión." unless impression_fields.all?
  end

  def impression_selected
    impression == 'si'
  end

end
