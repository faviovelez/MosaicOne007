class RemoveStoreFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :store_code, :string
    remove_column :requests, :store_name, :string
  end
end
