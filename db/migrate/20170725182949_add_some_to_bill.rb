class AddSomeToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :store, index: true, foreign_key: true
    add_column :bills, :amount, :float
    add_column :bills, :quantity, :integer
  end
end
