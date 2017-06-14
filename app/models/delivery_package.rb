class DeliveryPackage < ActiveRecord::Base
  belongs_to :order
end
