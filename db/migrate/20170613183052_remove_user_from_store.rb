class RemoveUserFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :user_id, :refernces
  end
end
