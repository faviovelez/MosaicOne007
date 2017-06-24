class AddDeliveryToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :delivery_address, index: true, foreign_key: true
  end
end
