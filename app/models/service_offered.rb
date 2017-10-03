class ServiceOffered < ActiveRecord::Base
  belongs_to :service
  belongs_to :store
  belongs_to :business_unit
  belongs_to :bill
end
