class RemoveStoreTypeFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :store_type, :string
  end
end
