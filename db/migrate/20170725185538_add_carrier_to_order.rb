class AddCarrierToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :carrier, index: true, foreign_key: true
  end
end
