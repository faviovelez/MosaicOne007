class AddNameToWithdrawal < ActiveRecord::Migration
  def change
    add_column :withdrawals, :name, :string
  end
end
