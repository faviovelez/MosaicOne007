class StoreMovement < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  belongs_to :ticket
  belongs_to :store
  belongs_to :return_ticket
  belongs_to :change_ticket
  belongs_to :tax
  belongs_to :supplier
  belongs_to :product_request
  belongs_to :ticket
  has_many :stores_warehouse_entries
  belongs_to :bill
end
