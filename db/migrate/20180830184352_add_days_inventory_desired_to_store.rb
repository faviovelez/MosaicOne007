class AddDaysInventoryDesiredToStore < ActiveRecord::Migration
  def change
    add_column :stores, :days_inventory_desired, :integer, default: 30
  end
end
