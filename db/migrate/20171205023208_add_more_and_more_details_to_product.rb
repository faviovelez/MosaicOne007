class AddMoreAndMoreDetailsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :factor, :float
    add_column :products, :average, :float
    add_column :products, :stores_discount, :float
    add_column :products, :franchises_discount, :float
  end
end
