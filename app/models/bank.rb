class Bank < ActiveRecord::Base
  has_many :terminals
  has_many :payments
end
