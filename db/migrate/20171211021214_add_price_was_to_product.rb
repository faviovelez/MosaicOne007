class AddPriceWasToProduct < ActiveRecord::Migration
  def change
    add_column :products, :price_was, :float
  end
end
