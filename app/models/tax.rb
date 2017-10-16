class Tax < ActiveRecord::Base
  has_many :bills
  has_many :tickets
  has_many :service_offereds
end
