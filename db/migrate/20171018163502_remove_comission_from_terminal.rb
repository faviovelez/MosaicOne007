class RemoveComissionFromTerminal < ActiveRecord::Migration
  def change
    remove_column :terminals, :comission, :float
  end
end
