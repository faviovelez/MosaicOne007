class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :key
      t.string :name

      t.timestamps null: false
    end
  end
end
