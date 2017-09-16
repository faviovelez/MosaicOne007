class CreateTypeOfBills < ActiveRecord::Migration
  def change
    create_table :type_of_bills do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
