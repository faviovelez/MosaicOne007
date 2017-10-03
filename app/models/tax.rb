class Tax < ActiveRecord::Base
  has_many :bills
  has_many :tickets
end
