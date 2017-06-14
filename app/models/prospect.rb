class Prospect < ActiveRecord::Base
  belongs_to :store
  belongs_to :request
  has_one :billing_address
  has_one :delivery_address
end
