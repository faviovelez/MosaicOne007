class AddExpenseTypeToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :expense_type, :string
    add_column :expenses, :taxes, :float
    add_reference :expenses, :payment, index: true, foreign_key: true
  end
end
