class CreateBusinessUnits < ActiveRecord::Migration
  def change
    create_table :business_units do |t|
      t.string :name
      t.references :billing_address, index: true, foreign_key: true
      t.references :delivery_address, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
