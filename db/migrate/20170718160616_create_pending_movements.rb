class CreatePendingMovements < ActiveRecord::Migration
  def change
    create_table :pending_movements do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.string :movement_type

      t.timestamps null: false
    end
  end
end
