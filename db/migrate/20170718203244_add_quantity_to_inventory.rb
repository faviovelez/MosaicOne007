class AddQuantityToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :quantity, :integer
  end
end
