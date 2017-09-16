class CreatePaymentConditions < ActiveRecord::Migration
  def change
    create_table :payment_conditions do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
