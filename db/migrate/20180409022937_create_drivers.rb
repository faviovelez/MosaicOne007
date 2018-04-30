class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :active

      t.timestamps null: false
    end
  end
end
