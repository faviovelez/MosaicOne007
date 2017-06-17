class RemoveManagerFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :manager, :string
  end
end
