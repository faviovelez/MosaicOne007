class AddTerminalToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :terminal, index: true, foreign_key: true
  end
end
