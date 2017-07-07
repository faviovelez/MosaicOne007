class RemoveStowFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :boxes_stow, :integer
  end
end
