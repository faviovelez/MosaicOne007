class AddDebitComissionToTerminal < ActiveRecord::Migration
  def change
    add_column :terminals, :debit_comission, :float
    add_column :terminals, :credit_comission, :float
  end
end
