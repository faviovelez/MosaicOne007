class Terminal < ActiveRecord::Base
  belongs_to :bank
  belongs_to :store
  has_many :payments
end
