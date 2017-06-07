class RemoveTypeFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :type, :string
  end
end
