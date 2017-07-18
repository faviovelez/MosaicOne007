class ChangeDefaultForInventory < ActiveRecord::Migration
  def change
    change_column :inventories, :quantity, :integer, default: 0
  end
end
