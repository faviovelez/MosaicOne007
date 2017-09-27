class AddDefaultToOverprice < ActiveRecord::Migration
  def change
    change_column :stores, :overprice, :float, default: 0
  end
end
