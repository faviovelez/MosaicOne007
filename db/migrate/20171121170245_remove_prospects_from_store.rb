class RemoveProspectsFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :prospects, :string
  end
end
