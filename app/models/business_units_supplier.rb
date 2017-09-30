class BusinessUnitsSupplier < ActiveRecord::Base
  belongs_to :business_unit
  belongs_to :supplier
end
