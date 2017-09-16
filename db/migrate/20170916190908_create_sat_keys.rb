class CreateSatKeys < ActiveRecord::Migration
  def change
    create_table :sat_keys do |t|
      t.string :sat_key
      t.string :description

      t.timestamps null: false
    end
  end
end
