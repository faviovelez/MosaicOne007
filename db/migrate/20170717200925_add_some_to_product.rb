class AddSomeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :bag_length, :float
    add_column :products, :bag_width, :float
    add_column :products, :bag_height, :float
    add_column :products, :exhibitor_height, :float
    add_column :products, :tray_quantity, :integer
    add_column :products, :tray_length, :float
    add_column :products, :tray_width, :float
    add_column :products, :tray_divisions, :integer
  end
end
