class Currency < ActiveRecord::Base
  has_many :bills
end
