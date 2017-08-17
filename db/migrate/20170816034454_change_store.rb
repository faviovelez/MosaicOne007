class ChangeStore < ActiveRecord::Migration
  def change
    change_column :stores, :reorder_point, :float, default: 50.0
    change_column :stores, :critical_point, :float, default: 25.0
  end
end
