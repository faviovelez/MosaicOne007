class AddUserToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :user, index: true, foreign_key: true
  end
end
