class CreateMaterialsResistances < ActiveRecord::Migration
  def change
    create_table :materials_resistances do |t|
      t.references :material, index: true, foreign_key: true
      t.references :resistance, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
