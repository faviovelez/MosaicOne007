class AddDeliveryToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :maximum_date, :date
  end
end
