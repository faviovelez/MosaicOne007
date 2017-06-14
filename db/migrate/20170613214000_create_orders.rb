class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.references :user, index: true, foreign_key: true
      t.references :delivery_address, index: true, foreign_key: true
      t.references :additional_discount, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
