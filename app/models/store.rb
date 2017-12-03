class Store < ActiveRecord::Base
  # Para crear o modificar nuevas tiendas.
  has_many :users
  has_many :requests
  has_many :prospects
  has_many :orders
  has_many :movements
  has_many :pending_movements
  belongs_to :delivery_address
  has_many :store_sales
  belongs_to :business_unit
  belongs_to :business_group
  belongs_to :store_type
  has_many :warehouses
  belongs_to :cost_type
  has_many :suppliers
  has_many :bills
  has_many :discount_rules
  has_one  :store_prospect, class_name: "Prospect", foreign_key: 'store_prospect_id'
  has_many :suppliers, through: :stores_suppliers
  has_many :stores_suppliers
  has_many :prospects
  has_many :products
  has_many :products, through: :stores_inventories
  has_many :stores_inventories
  has_many :products, through: :stores_warehouse_entries
  has_many :movements, through: :stores_warehouse_entries
  has_many :stores_warehouse_entries
  has_many :bill_sales
  has_many :services
  has_many :service_offereds
  has_many :store_use_inventories
  has_many :exhibition_inventories
  has_many :tickets
  has_many :estimate_docs
  has_many :deposits
  has_one :bank_balance
  has_many :terminals
  has_many :expenses
  has_many :payments
  has_many :temporal_numbers
  has_many :cash_registers
  has_many :store_movements
  has_many :prospect_sales
  has_many :product_sales
  has_many :store_sales
  has_many :business_unit_sales
  has_many :business_group_sales
  mount_uploader :certificate, SatCertificateUploader
  mount_uploader :key, SatKeyUploader
  mount_uploader :initial_inventory, InitialInventoryUploader
  mount_uploader :current_inventory, CurrentInventoryUploader
  mount_uploader :prospects_file, ProspectsUploader

  validates :store_name, presence: { message: 'Debe especificar el nombre de la tienda.'}

  validates :store_code, presence: { message: 'Debe especificar un código para la tienda.'}

############################################################
#CAMBIAR TODA ESTA LÓGICA AL TENER UN BUSCADOR CON AJAX
  validate :zip_code_is_in_sat_list, :uniq_install_code

  before_create :gen_install_code

  @@value = true

  def self.my_validation(value)
    @@value = value
  end

  def zip_code_is_in_sat_list
    errors[:base] << "El código postal elegido no se encuentra en la base del SAT, por favor elija otro." if @@value == false
  end
############################################################

  def gen_install_code(max = 4)
    code = gen_random(self.store_name, max) + " "
    code += gen_random(full_name_contact, max) + " "
    code += gen_random(self.store_code, max)
    self.install_code = "#{code} #{gen_random(code, max)}"
  end

  def full_name_contact
    full_name = ''
    %w(
      contact_first_name contact_middle_name
      contact_last_name second_last_name
    ).each do |field|
      full_name += "#{self.send(field)} "
    end
    full_name
  end

  private

    def gen_random(cad, max = 4)
      cad = cad.gsub(/\s+/, "")
      (0...max).map do |n|
        cad[rand(cad.length - 1)]
      end.join
    end

    def uniq_install_code
      count = 3
      if Store.where(install_code: self.install_code).first.present?
        gen_install_code(count+= 1)
      end
    end

end
