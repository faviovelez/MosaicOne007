class ServicesTicket < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :service
end
