class CreateMaterialsImpressionTypes < ActiveRecord::Migration
  def change
    create_table :materials_impression_types do |t|
      t.references :material, index: true, foreign_key: true
      t.references :impression_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
