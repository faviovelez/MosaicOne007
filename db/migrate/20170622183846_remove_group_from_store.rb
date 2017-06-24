class RemoveGroupFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :group, :string
  end
end
