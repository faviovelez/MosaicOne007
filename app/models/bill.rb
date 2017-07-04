class Bill < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  has_one :additional_discount
end
