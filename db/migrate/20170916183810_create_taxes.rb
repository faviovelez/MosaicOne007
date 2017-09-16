class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :description
      t.float :value

      t.timestamps null: false
    end
  end
end
