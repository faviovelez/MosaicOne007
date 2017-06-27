class AddExhibitorToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :exhibitor_height, :float
    add_column :requests, :tray_quantity, :integer
    add_column :requests, :tray_length, :float
    add_column :requests, :tray_width, :float
    add_column :requests, :tray_divisions, :integer
  end
end
