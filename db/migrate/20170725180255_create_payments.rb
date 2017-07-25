class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :payment_date
      t.float :amount
      t.references :bill_received, index: true, foreign_key: true
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
