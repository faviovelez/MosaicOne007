class AddManagerToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :manager, :string
  end
end
