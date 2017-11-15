class AddInventoryFilesToStore < ActiveRecord::Migration
  def change
    add_column :stores, :initial_inventory, :string
    add_column :stores, :current_inventory, :string
    add_column :stores, :prospects, :string
  end
end
