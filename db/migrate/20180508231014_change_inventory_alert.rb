class ChangeInventoryAlert < ActiveRecord::Migration
  def change
    change_column :inventories, :alert, :boolean, default: false
  end
end
