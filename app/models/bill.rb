class Bill < ActiveRecord::Base
  belongs_to :product_catalog
  belongs_to :order
  has_one :additional_discount
end
