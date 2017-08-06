class AddConfirmToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :confirm, :boolean, default: false
  end
end
