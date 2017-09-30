class CreateBusinessUnitsSuppliers < ActiveRecord::Migration
  def change
    create_table :business_units_suppliers do |t|
      t.references :business_unit, index: true, foreign_key: true
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
