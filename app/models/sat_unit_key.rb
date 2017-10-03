class SatUnitKey < ActiveRecord::Base
  has_many :products
  has_many :services
end
