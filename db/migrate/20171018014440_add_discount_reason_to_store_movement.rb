class AddDiscountReasonToStoreMovement < ActiveRecord::Migration
  def change
    add_column :store_movements, :discount_reason, :string
  end
end
