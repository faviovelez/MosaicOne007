class AddIdentifierToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :identifier, :string
  end
end
