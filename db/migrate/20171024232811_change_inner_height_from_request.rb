class ChangeInnerHeightFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :inner_height, :string
    add_column :requests, :inner_height, :float
  end
end
