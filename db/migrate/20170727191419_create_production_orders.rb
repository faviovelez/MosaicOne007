class CreateProductionOrders < ActiveRecord::Migration
  def change
    create_table :production_orders do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
