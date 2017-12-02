class AddPosWebToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :pos, :boolean, default: false
    add_column :expenses, :web, :boolean, default: true
    add_column :expenses, :date, :date
  end
end
