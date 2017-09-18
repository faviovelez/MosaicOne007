class DiscountRule < ActiveRecord::Base
  belongs_to :givaway
  belongs_to :business_unit
  belongs_to :store
  belongs_to :user
end
