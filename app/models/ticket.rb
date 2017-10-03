class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :tax
  belongs_to :prospect
  belongs_to :payment
  belongs_to :bill
  has_many :products, through: :products_tickets
  has_many :products_tickets
  has_many :services_tickets
  has_many :services, through: :services_tickets
  has_many :movements
  has_many :pending_movements
end
