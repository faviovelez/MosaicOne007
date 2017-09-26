class AddOverpriceToStore < ActiveRecord::Migration
  def change
    add_column :stores, :overprice, :float
  end
end
