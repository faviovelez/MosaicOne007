class Product < ActiveRecord::Base
  # Catálogo de productos para todos los usuarios.
  has_many :images, dependent: :destroy
  has_many :movements, dependent: :destroy
  has_many :pending_movements, dependent: :destroy
  has_one :inventory, dependent: :destroy
  has_many :bill_receiveds, dependent: :destroy
  has_many :products_bills, dependent: :destroy
  has_many :bills, through: :products_bills, dependent: :destroy
  has_many :product_requests, dependent: :destroy
  has_many :product_sales, dependent: :destroy
  has_many :warehouse_entries
  belongs_to :business_unit
  has_many :production_requests, dependent: :destroy
  has_one :request, dependent: :destroy
  belongs_to :warehouse
  belongs_to :sat_key
  belongs_to :sat_unit_key
  belongs_to :supplier
  belongs_to :store
  has_many :stores, through: :stores_inventories
  has_many :stores_inventories
  has_many :stores, through: :stores_warehouse_entries
  has_many :movements, through: :stores_warehouse_entries
  has_many :stores_warehouse_entries
  has_many :store_use_inventories
  has_many :exhibition_inventories
  has_many :products_tickets
  has_many :tickets, through: :products_tickets
  has_many :estimates
  belongs_to :parent, class_name: 'Product', foreign_key: 'parent_id'
  belongs_to :child, class_name: 'Product', foreign_key: 'child_id'

  validates :unique_code, presence: { message: "Debe anotar un código de producto."}

  validate :price_present, unless: :classification_is_special

  validates :unique_code, uniqueness: { message: "El código de producto no se puede repetir, ya existe un producto con con este código." }

  after_create :create_inventory_or_store_inventories

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

  def create_store_inventories
    if self.classification == 'de línea'
      corporate = StoreType.find_by_store_type('corporativo')
      stores = Store.where.not(store_type: corporate)
      stores.each do |store|
        StoresInventory.create(product: self, store: self.store) unless self.store.stores_inventories.where(product: self).count > 0
      end
    end
  end

  def create_inventory_or_store_inventories
    if self.classification == 'de tienda'
      inventory = StoresInventory.create(product: self, store: self.store) unless self.store.stores_inventories.where(product: self).count > 0
    else
      self.update(shared: true)
      create_store_inventories
      create_corporate_inventory
    end
  end

  def create_corporate_inventory
    inventory_corp = Inventory.create(product: self, unique_code: self.unique_code)
  end

  def price_present
      errors[:base] << "Es necesario el precio del producto." if price.blank?
  end

  def classification_is_special
    classification == 'especial'
  end

  def update_inventory_quantity(quantity, type)
    actual_quantity = self.inventory.quantity
    if (type == 'alta' || type == 'devolución')
      self.inventory.update(
        quantity: actual_quantity + quantity
      )
    else
      self.inventory.update(
        quantity: actual_quantity - quantity
      )
    end
  end

  def quantity
    inventory.try(:quantity) || 0
  end

  def movements_quantity
    pending_movements.sum(:quantity) || 0
  end

  def valid_inventory
    final_inventory = quantity
    if final_inventory < 0
      return 0
    end
    final_inventory
  end

  class << self
    def has_inventory(find = nil)
      if find.nil?
        return all.select {|product| product.inventory }
      end
      query = ''
      %w(unique_code description).each do |field|
        query << "#{field} LIKE ? or "
      end
      query << "exterior_color_or_design LIKE ?"
      where(query, "%#{find}%", "%#{find}%", "%#{find}%")
    end
  end
end
