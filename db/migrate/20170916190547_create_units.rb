class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
