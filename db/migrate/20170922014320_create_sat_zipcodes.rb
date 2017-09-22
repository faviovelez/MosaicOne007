class CreateSatZipcodes < ActiveRecord::Migration
  def change
    create_table :sat_zipcodes do |t|
      t.string :zipcode

      t.timestamps null: false
    end
  end
end
