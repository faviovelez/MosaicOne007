class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :business_type

      t.timestamps null: false
    end
  end
end
