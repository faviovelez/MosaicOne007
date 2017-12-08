class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :tax
  belongs_to :prospect
  belongs_to :bill
  belongs_to :cash_register
  has_many :movements
  has_many :pending_movements
  has_many :store_movements
  has_many :service_offereds
  belongs_to :cfdi_use
  has_many :payments
  has_many :children, through: :tickets_child, foreign_key: 'children_id'
  has_many :tickets_child
  belongs_to :parent, class_name: 'Ticket', foreign_key: 'parent_id'

end
