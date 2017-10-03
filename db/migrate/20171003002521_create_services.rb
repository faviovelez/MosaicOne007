class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :unique_code
      t.text :description
      t.float :price
      t.references :sat_key, index: true, foreign_key: true
      t.string :unit
      t.references :sat_unit_key, index: true, foreign_key: true
      t.boolean :shared
      t.references :store, index: true, foreign_key: true
      t.references :business_unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
