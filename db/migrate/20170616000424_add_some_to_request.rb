class AddSomeToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :store_code, :string
    add_column :requests, :store_name, :string
  end
end
