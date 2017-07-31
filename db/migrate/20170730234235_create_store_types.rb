class CreateStoreTypes < ActiveRecord::Migration
  def change
    create_table :store_types do |t|
      t.string :store_type
      t.references :business_unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
