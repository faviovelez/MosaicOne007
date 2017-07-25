class Supplier < ActiveRecord::Base
  has_many :bill_receiveds
  has_many :payments
  has_many :movements
  has_many :pending_movements
end
