class AddPosWebToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pos, :boolean, default: false
    add_column :products, :web, :boolean, default: false
    add_column :products, :date, :date
    add_column :products, :discount_for_stores, :float, default: 0
    add_column :products, :discount_for_franchises, :float, default: 0
  end
end
