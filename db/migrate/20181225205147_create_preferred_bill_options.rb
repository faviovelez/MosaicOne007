class CreatePreferredBillOptions < ActiveRecord::Migration
  def change
    create_table :preferred_bill_options do |t|
      t.references :prospect, index: true, foreign_key: true
      t.references :payment_form, index: true, foreign_key: true
      t.references :payment_method, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
