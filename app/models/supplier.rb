class Supplier < ActiveRecord::Base
  has_many :bill_receiveds
  has_many :payments
  has_many :movements
  has_many :pending_movements
  has_many :business_groups, through: :business_groups_suppliers
  has_many :business_groups_suppliers
  belongs_to :delivery_address
  belongs_to :store
end
