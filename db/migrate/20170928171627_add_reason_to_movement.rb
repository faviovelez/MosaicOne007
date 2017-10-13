class AddReasonToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :reason, :string
  end
end
