class AddStatusToProductionOrder < ActiveRecord::Migration
  def change
    add_column :production_orders, :status, :string
  end
end
