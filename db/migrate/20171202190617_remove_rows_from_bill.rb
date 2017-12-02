class RemoveRowsFromBill < ActiveRecord::Migration
  def change
    remove_column :bills, :rows, :text
  end
end
