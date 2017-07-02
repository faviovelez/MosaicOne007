class RemoveAnotherFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :payment, :boolean
  end
end
