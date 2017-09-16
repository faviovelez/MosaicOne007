class CreatePaymentForms < ActiveRecord::Migration
  def change
    create_table :payment_forms do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
