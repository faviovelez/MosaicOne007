class AddStoreTypeToStore < ActiveRecord::Migration
  def change
    add_column :stores, :store_type, :string
  end
end
