class CreateOrdersUsers < ActiveRecord::Migration
  def change
    create_table :orders_users do |t|
      t.references :order, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
