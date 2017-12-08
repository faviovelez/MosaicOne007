class AddArmedToProduct < ActiveRecord::Migration
  def change
    add_column :products, :armed, :boolean, default: false
    add_column :products, :armed_discount, :float, default: 0
  end
end
