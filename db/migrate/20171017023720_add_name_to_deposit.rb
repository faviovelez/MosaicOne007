class AddNameToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :name, :string
  end
end
