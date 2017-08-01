class StoreType < ActiveRecord::Base
  belongs_to :business_unitç
  has_many :stores
end
