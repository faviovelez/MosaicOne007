class AddDetailsToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :user, index: true, foreign_key: true
    add_reference :payments, :store, index: true, foreign_key: true
    add_reference :payments, :business_unit, index: true, foreign_key: true
    add_reference :payments, :payment_form, index: true, foreign_key: true
  end
end
