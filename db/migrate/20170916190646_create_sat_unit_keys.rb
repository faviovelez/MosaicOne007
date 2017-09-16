class CreateSatUnitKeys < ActiveRecord::Migration
  def change
    create_table :sat_unit_keys do |t|
      t.string :unit
      t.string :description

      t.timestamps null: false
    end
  end
end
