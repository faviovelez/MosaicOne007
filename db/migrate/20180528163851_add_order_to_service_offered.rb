class AddOrderToServiceOffered < ActiveRecord::Migration
  def change
    add_reference :service_offereds, :order, index: true, foreign_key: true
  end
end
