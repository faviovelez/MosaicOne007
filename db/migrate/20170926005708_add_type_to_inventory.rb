class AddTypeToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :alert_type, :string
  end
end
