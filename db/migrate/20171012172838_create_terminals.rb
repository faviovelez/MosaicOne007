class CreateTerminals < ActiveRecord::Migration
  def change
    create_table :terminals do |t|
      t.string :name
      t.references :bank, index: true, foreign_key: true
      t.string :number
      t.float :comission
      t.references :store, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
