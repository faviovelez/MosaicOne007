class Tax < ActiveRecord::Base
  has_many :bills
end
