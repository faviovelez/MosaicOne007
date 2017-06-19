class RemoveUserFromRoles < ActiveRecord::Migration
  def change
    remove_reference :roles, :user, index: true, foreign_key: true
  end
end
