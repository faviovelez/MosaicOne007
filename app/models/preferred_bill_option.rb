class PreferredBillOption < ActiveRecord::Base
  belongs_to :prospect
  belongs_to :payment_form
  belongs_to :payment_method
end
