class AddTicketToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :ticket, index: true, foreign_key: true
    add_column :payments, :operation_number, :string
    add_column :payments, :payment_number, :integer
  end
end
