class AddNameToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :name_type, :string
  end
end
