class AddUniqueCodeToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :unique_code, :string
  end
end
