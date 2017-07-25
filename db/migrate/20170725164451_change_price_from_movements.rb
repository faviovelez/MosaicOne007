class ChangePriceFromMovements < ActiveRecord::Migration
  def change
    rename_column :movements, :price, :initial_price
  end
end
