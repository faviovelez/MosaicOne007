class Service < ActiveRecord::Base
  belongs_to :sat_key
  belongs_to :sat_unit_key
  belongs_to :store
  belongs_to :business_unit
  has_many :service_offereds
end
