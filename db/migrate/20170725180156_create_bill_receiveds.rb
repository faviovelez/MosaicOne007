class CreateBillReceiveds < ActiveRecord::Migration
  def change
    create_table :bill_receiveds do |t|
      t.string :folio
      t.date :date_of_bill
      t.float :subtotal
      t.float :taxes_rate
      t.float :taxes
      t.float :total_amount
      t.references :supplier, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.date :payment_day
      t.boolean :payment_complete
      t.boolean :payment_on_time

      t.timestamps null: false
    end
  end
end
