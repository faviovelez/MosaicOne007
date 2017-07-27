class CreateProductionRequests < ActiveRecord::Migration
  def change
    create_table :production_requests do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.string :status
      t.references :production_order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
