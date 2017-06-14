class AddFieldsToStore < ActiveRecord::Migration
  def change
    add_column :stores, :store_code, :string
    add_column :stores, :store_name, :string
    add_column :stores, :group, :string
    add_column :stores, :discount, :float
  end
end
