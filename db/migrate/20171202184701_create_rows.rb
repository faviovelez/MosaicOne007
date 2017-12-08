class CreateRows < ActiveRecord::Migration
  def change
    create_table :rows do |t|
      t.references :bill, index: true, foreign_key: true
      t.integer :product
      t.integer :service
      t.string :unique_code
      t.integer :quantity
      t.float :unit_value
      t.integer :ticket
      t.string :sat_key
      t.string :sat_unit_key
      t.string :description
      t.float :total
      t.float :subtotal
      t.float :taxes
      t.float :discount
      t.string :sat_unit_description

      t.timestamps null: false
    end
  end
end
