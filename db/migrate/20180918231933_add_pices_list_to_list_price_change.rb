class AddPicesListToListPriceChange < ActiveRecord::Migration
  def change
    add_column :list_price_changes, :list_type, :string
  end
end
