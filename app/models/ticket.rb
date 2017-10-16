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

  # Estos ya no #
  has_many :products, through: :products_tickets
  has_many :products_tickets
  has_many :services_tickets
  has_many :services, through: :services_tickets
  # Estos ya no #

end
