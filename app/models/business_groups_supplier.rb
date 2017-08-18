class BusinessGroupsSupplier < ActiveRecord::Base
  belongs_to :business_group
  belongs_to :supplier
end
