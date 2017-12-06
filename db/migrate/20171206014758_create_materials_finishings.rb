class CreateMaterialsFinishings < ActiveRecord::Migration
  def change
    create_table :materials_finishings do |t|
      t.references :material, index: true, foreign_key: true
      t.references :finishing, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
