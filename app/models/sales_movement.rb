class SalesMovement < ActiveRecord::Base
  belongs_to :sales, class_name: 'Movement', foreign_key: 'sales_id'
  belongs_to :movement
end
