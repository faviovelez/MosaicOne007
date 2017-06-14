class BillingAddress < ActiveRecord::Base
  belongs_to :prospect
  belongs_to :store
end
