class AddPosWebIdsToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :pos_id, :integer
    add_column :expenses, :web_id, :integer
  end
end
