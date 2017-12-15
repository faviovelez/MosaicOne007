class ServiceSale < ActiveRecord::Base
  belongs_to :store
  belongs_to :service
end
